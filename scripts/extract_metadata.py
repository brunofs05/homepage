"""
extract_metadata.py
-------------------
Lê os arquivos de imagem em images/ e extrai metadados EXIF de cada um,
produzindo images/photos.json — a fonte de verdade dos metadados das fotos.

Modo de operação (incremental por padrão):
  - Carrega photos.json existente, se houver.
  - Processa apenas fotos que ainda não estão no JSON.
  - Remove registros de fotos que foram deletadas de images/.
  - Resultado: re-ordenado por date e salvo.

  Use --force para ignorar o JSON existente e reprocessar tudo.

Por que incremental?
  EXIF reading é leve, mas o princípio vale: não refazer trabalho já feito.
  Se o arquivo já foi processado e não mudou, o resultado seria idêntico.
  Fotos novas entram; fotos deletadas saem. O JSON acompanha o estado real.

Campos extraídos:
  filename    → nome do arquivo (chave que o JS usa pra montar o src)
  date        → data ISO 8601 (YYYY-MM-DD), source: DateTimeOriginal EXIF
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
  - O script é idempotente: rodar duas vezes sem mudanças produz o mesmo resultado.
"""

import argparse
import json
from datetime import datetime
from pathlib import Path

from PIL import ExifTags, Image, ImageOps

# ── Configuração ──────────────────────────────────────────────────────────────

IMAGES_DIR = Path(__file__).parent.parent / "images"
OUTPUT_FILE = IMAGES_DIR / "photos.json"
VALID_EXTENSIONS = {".jpg", ".jpeg"}

# Tags EXIF que nos interessam (IDs numéricos do padrão EXIF/TIFF)
# Documentados aqui para dispensar o leitor de consultar ExifTags.TAGS.
EXIF_DATE_ORIGINAL = 0x9003  # DateTimeOriginal: quando a foto foi tirada
EXIF_FNUMBER       = 0x829D  # FNumber: abertura da lente (ex: 2.2 → f/2.2)
EXIF_WIDTH         = 0xA002  # ExifImageWidth
EXIF_HEIGHT        = 0xA003  # ExifImageHeight
EXIF_MAKE          = 0x010F  # Make: fabricante (IFD principal)
EXIF_MODEL         = 0x0110  # Model: modelo do aparelho (IFD principal)


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
    """Converte FNumber (ex: 1.79) para 'f/X.X'. Retorna None se inválido."""
    try:
        return f"f/{float(fnumber):.1f}"
    except (TypeError, ValueError):
        return None


def clean_string(value) -> str | None:
    """Remove null bytes e espaços excedentes de strings EXIF.
    Fabricantes costumam preencher campos com \\x00 para completar tamanho fixo."""
    if value is None:
        return None
    if isinstance(value, bytes):
        value = value.decode("utf-8", errors="replace")
    cleaned = str(value).replace("\x00", "").strip()
    return cleaned if cleaned else None


def extract_metadata(image_path: Path) -> dict:
    """Extrai metadados EXIF de um arquivo de imagem.
    Campos ausentes no EXIF são null, não omitidos — preserva a forma do objeto."""
    meta = {
        "filename":   image_path.name,
        "date":       None,
        "make":       None,
        "model":      None,
        "aperture":   None,
        "width":      None,
        "height":     None,
        "size_bytes": image_path.stat().st_size,
    }

    try:
        with Image.open(image_path) as img:
            # Corrige orientação EXIF antes de ler dimensões
            # (fotos verticais têm width/height invertidos sem isso)
            img = ImageOps.exif_transpose(img)
            meta["width"], meta["height"] = img.size

            exif = img.getexif()
            if not exif:
                return meta

            # Campos do IFD principal
            meta["make"]  = clean_string(exif.get(EXIF_MAKE))
            meta["model"] = clean_string(exif.get(EXIF_MODEL))

            # Sub-IFD EXIF: FNumber, DateTimeOriginal, dimensões da câmera
            ifd = exif.get_ifd(0x8769)

            raw_date = ifd.get(EXIF_DATE_ORIGINAL)
            meta["date"] = parse_exif_date(raw_date) if raw_date else None

            raw_fnumber = ifd.get(EXIF_FNUMBER)
            meta["aperture"] = format_aperture(raw_fnumber) if raw_fnumber else None

            # Dimensões do sub-IFD EXIF (mais confiáveis que as do PIL pós-transpose)
            exif_w = ifd.get(EXIF_WIDTH)
            exif_h = ifd.get(EXIF_HEIGHT)
            if exif_w and exif_h:
                meta["width"]  = int(exif_w)
                meta["height"] = int(exif_h)

    except Exception as e:
        # Imagem ilegível: registra o aviso mas não interrompe o processo.
        # O registro entra no JSON com os campos que foram possíveis extrair.
        print(f"  ⚠  {image_path.name}: {e}")

    return meta


# ── Execução principal ────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(
        description="Extrai metadados EXIF das fotos e gera images/photos.json."
    )
    parser.add_argument(
        "--force",
        action="store_true",
        help="Ignora o JSON existente e reprocessa todas as fotos.",
    )
    args = parser.parse_args()

    # Descobre todos os arquivos de imagem válidos em images/
    image_files = {
        p.name: p
        for p in IMAGES_DIR.iterdir()
        if p.is_file() and p.suffix.lower() in VALID_EXTENSIONS
    }

    # ── Modo incremental: carrega o que já foi processado ─────────────────────
    existing: dict[str, dict] = {}
    if not args.force and OUTPUT_FILE.exists():
        for record in json.loads(OUTPUT_FILE.read_text(encoding="utf-8")):
            existing[record["filename"]] = record

    # Fotos novas: estão em images/ mas não estão no JSON ainda
    new_filenames = set(image_files) - set(existing)

    # Fotos deletadas: estão no JSON mas o arquivo sumiu de images/
    # → simplesmente não as carregamos no existing filtrado
    kept_existing = {
        name: record
        for name, record in existing.items()
        if name in image_files
    }

    deleted_count = len(existing) - len(kept_existing)

    # ── Processa apenas as fotos novas ────────────────────────────────────────
    new_records = []
    if new_filenames:
        print(f"Processando {len(new_filenames)} foto(s) nova(s):")
        for name in sorted(new_filenames):
            meta = extract_metadata(image_files[name])
            new_records.append(meta)
            date_display = meta["date"] or "(sem data EXIF)"
            print(f"  ✓  {name:45s}  {date_display}")
    else:
        print("Nenhuma foto nova encontrada.")

    if deleted_count:
        print(f"Removidos {deleted_count} registro(s) de fotos deletadas.")

    if args.force:
        print(f"--force: reprocessando todas as {len(image_files)} fotos.")

    # ── Mescla existentes + novos, reordena e salva ───────────────────────────
    all_records = list(kept_existing.values()) + new_records
    all_records.sort(key=lambda r: r["date"] or "9999-99-99")

    OUTPUT_FILE.write_text(
        json.dumps(all_records, ensure_ascii=False, indent=2),
        encoding="utf-8",
    )

    print(f"\n✓ {OUTPUT_FILE.name} atualizado — {len(all_records)} registro(s) no total.")


if __name__ == "__main__":
    main()
