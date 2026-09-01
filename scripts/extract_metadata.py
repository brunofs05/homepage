"""
extract_metadata.py
-------------------
Lê os arquivos de imagem em images/ e extrai metadados EXIF de cada um,
produzindo images/photos.json — a fonte de verdade dos metadados das fotos.

Por que esse script existe?
  Antes, os metadados (data, sensor, abertura) ficavam hardcoded no HTML.
  Isso é uma "expectativa implícita": qualquer mudança de nomenclatura
  (ex: data-aperture → data-focal) quebrava silenciosamente.
  Com um JSON gerado aqui e um contrato validado no CI,
  a quebra vira detectável antes de chegar ao browser.

Campos extraídos:
  filename    → nome do arquivo (chave de referência para o HTML/JS)
  date        → data da foto em ISO 8601 (YYYY-MM-DD), source: DateTimeOriginal EXIF
  make        → fabricante do aparelho (ex: "Xiaomi")
  model       → modelo do aparelho (ex: "Mi A3")
  aperture    → abertura em formato f/X.X (ex: "f/1.8"), source: FNumber EXIF
  width       → largura em pixels
  height      → altura em pixels
  size_bytes  → tamanho do arquivo original em bytes

Decisões de design:
  - Campos ausentes no EXIF ficam null, não são omitidos.
    Isso preserva a forma do objeto e facilita a validação do contrato.
  - date usa DateTimeOriginal (quando a foto foi tirada),
    não DateTime (quando foi processada/editada).
  - Ordenação é por date ASC; fotos sem date vão pro final.
  - O script é idempotente: rodar duas vezes produz o mesmo resultado.
"""

import json
import os
from datetime import datetime
from pathlib import Path

from PIL import ExifTags, Image, ImageOps

# ── Configuração ──────────────────────────────────────────────────────────────

IMAGES_DIR = Path(__file__).parent.parent / "images"
OUTPUT_FILE = IMAGES_DIR / "photos.json"
VALID_EXTENSIONS = {".jpg", ".jpeg"}

# Tags EXIF que nos interessam (IDs numéricos do padrão EXIF/TIFF)
# Consultados via PIL.ExifTags.TAGS — documentados aqui para dispensar
# o leitor de conhecer os números de cor de cabeça.
EXIF_DATE_ORIGINAL = 0x9003  # DateTimeOriginal: quando a foto foi tirada
EXIF_FNUMBER = 0x829D        # FNumber: abertura da lente (ex: 2.2 → f/2.2)
EXIF_WIDTH = 0xA002          # ExifImageWidth
EXIF_HEIGHT = 0xA003         # ExifImageHeight

# Tags do IFD principal (não do sub-IFD EXIF)
EXIF_MAKE = 0x010F           # Make: fabricante
EXIF_MODEL = 0x0110          # Model: modelo do aparelho


# ── Funções auxiliares ────────────────────────────────────────────────────────

def parse_exif_date(raw: str) -> str | None:
    """Converte 'YYYY:MM:DD HH:MM:SS' (formato EXIF) para 'YYYY-MM-DD' (ISO 8601).
    Retorna None se o valor não estiver no formato esperado."""
    try:
        dt = datetime.strptime(raw.strip(), "%Y:%m:%d %H:%M:%S")
        return dt.strftime("%Y-%m-%d")
    except (ValueError, AttributeError):
        return None


def format_aperture(fnumber: float) -> str | None:
    """Converte o número FNumber (ex: 1.79) para o formato de exibição 'f/X.X'.
    Retorna None se o valor não for numérico."""
    try:
        return f"f/{float(fnumber):.1f}"
    except (TypeError, ValueError):
        return None


def clean_string(value) -> str | None:
    """Remove null bytes e espaços excedentes de strings EXIF.
    Fabricantes costumam preencher campos com \\x00 pra completar tamanho fixo."""
    if value is None:
        return None
    if isinstance(value, bytes):
        value = value.decode("utf-8", errors="replace")
    cleaned = str(value).replace("\x00", "").strip()
    return cleaned if cleaned else None


def extract_metadata(image_path: Path) -> dict:
    """Extrai metadados de um arquivo de imagem e retorna um dicionário.
    Campos ausentes no EXIF são representados como null (None), não omitidos.
    """
    meta = {
        "filename": image_path.name,
        "date": None,
        "make": None,
        "model": None,
        "aperture": None,
        "width": None,
        "height": None,
        "size_bytes": image_path.stat().st_size,
    }

    try:
        with Image.open(image_path) as img:
            # Corrige orientação EXIF antes de ler dimensões
            # (fotos tiradas na vertical têm width/height invertidos sem isso)
            img = ImageOps.exif_transpose(img)
            meta["width"], meta["height"] = img.size

            exif = img.getexif()
            if not exif:
                return meta

            # Campos do IFD principal
            meta["make"] = clean_string(exif.get(EXIF_MAKE))
            meta["model"] = clean_string(exif.get(EXIF_MODEL))

            # Sub-IFD EXIF: onde ficam FNumber, DateTimeOriginal, dimensões
            ifd = exif.get_ifd(0x8769)

            raw_date = ifd.get(EXIF_DATE_ORIGINAL)
            meta["date"] = parse_exif_date(raw_date) if raw_date else None

            raw_fnumber = ifd.get(EXIF_FNUMBER)
            meta["aperture"] = format_aperture(raw_fnumber) if raw_fnumber else None

            # Dimensões do IFD EXIF (mais confiáveis que as do PIL pós-transpose)
            exif_w = ifd.get(EXIF_WIDTH)
            exif_h = ifd.get(EXIF_HEIGHT)
            if exif_w and exif_h:
                meta["width"] = int(exif_w)
                meta["height"] = int(exif_h)

    except Exception as e:
        # Se a imagem for ilegível, registramos o erro mas não interrompemos
        # o processo — o JSON será gerado com os campos que foram possíveis.
        print(f"  ⚠  {image_path.name}: {e}")

    return meta


# ── Execução principal ────────────────────────────────────────────────────────

def main():
    image_files = sorted(
        p for p in IMAGES_DIR.iterdir()
        if p.is_file() and p.suffix.lower() in VALID_EXTENSIONS
    )

    print(f"Encontradas {len(image_files)} imagens em {IMAGES_DIR}")

    records = []
    for path in image_files:
        meta = extract_metadata(path)
        records.append(meta)
        date_display = meta["date"] or "(sem data EXIF)"
        print(f"  ✓  {meta['filename']:45s}  {date_display}")

    # Ordena por date ASC; fotos sem date (None) vão para o final
    records.sort(key=lambda r: r["date"] or "9999-99-99")

    OUTPUT_FILE.write_text(
        json.dumps(records, ensure_ascii=False, indent=2),
        encoding="utf-8"
    )

    print(f"\n✓ Gerado: {OUTPUT_FILE}  ({len(records)} registros)")


if __name__ == "__main__":
    main()
