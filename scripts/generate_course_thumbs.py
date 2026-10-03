"""
generate_course_thumbs.py
-------------------------
Padroniza as imagens de capa dos cursos: lê o que estiver em images/courses-thumbs/
(qualquer tamanho/formato) e escreve images/courses/<curso>.jpg, quadrado e pequeno.

Convenção: o nome do arquivo (sem extensão) é o slug do curso, o mesmo de
courses/<slug>.typ.  Ex: images/courses-thumbs/timeseries.png → images/courses/timeseries.jpg

Por que 200x200?
  O .card-thumb no CSS tem 100x100 px. Guardamos 2x para telas de alta densidade
  (retina); mais que isso é bytes desperdiçados.

Como o recorte funciona:
  ImageOps.fit redimensiona e corta no centro até a proporção 1:1 (equivale ao
  object-fit: cover do CSS, mas feito uma vez só, em vez de o browser baixar a
  imagem grande e descartar o excesso).

Transparência:
  JPEG não tem canal alfa. PNGs com fundo transparente são achatados sobre branco.

Originais:
  Depois de gerar o resultado com sucesso, o original é apagado (a pasta de entrada
  funciona como "caixa de entrada"). Use --keep para preservá-los.

Uso:
  .venv/bin/python scripts/generate_course_thumbs.py          # processa e apaga originais
  .venv/bin/python scripts/generate_course_thumbs.py --keep   # processa e mantém originais
"""

import argparse
from pathlib import Path

from PIL import Image, ImageOps

ROOT    = Path(__file__).parent.parent
IN_DIR  = ROOT / "images" / "courses-thumbs"
OUT_DIR = ROOT / "images" / "courses"
SIZE    = (200, 200)
QUALITY = 85
VALID_EXTENSIONS = {".jpg", ".jpeg", ".png", ".webp"}


def to_rgb(img: Image.Image) -> Image.Image:
    """Achata transparência sobre fundo branco e garante modo RGB."""
    img = ImageOps.exif_transpose(img)  # respeita a rotação gravada no EXIF
    if img.mode in ("RGBA", "LA", "P"):
        img = img.convert("RGBA")
        background = Image.new("RGB", img.size, "white")
        background.paste(img, mask=img.getchannel("A"))
        return background
    return img.convert("RGB")


def main():
    parser = argparse.ArgumentParser(description="Gera capas 200x200 dos cursos.")
    parser.add_argument("--keep", action="store_true", help="não apaga os originais")
    args = parser.parse_args()

    OUT_DIR.mkdir(exist_ok=True)
    sources = sorted(p for p in IN_DIR.iterdir() if p.suffix.lower() in VALID_EXTENSIONS)

    if not sources:
        print(f"nada para processar em {IN_DIR.relative_to(ROOT)}/")
        return

    for src in sources:
        dest = OUT_DIR / f"{src.stem}.jpg"
        with Image.open(src) as img:
            thumb = ImageOps.fit(to_rgb(img), SIZE, Image.LANCZOS)
            thumb.save(dest, "JPEG", quality=QUALITY, optimize=True)
        print(f"gerado: {dest.relative_to(ROOT)} ({dest.stat().st_size // 1024} KB)")

        # só apaga depois de o resultado estar salvo
        if not args.keep:
            src.unlink()


if __name__ == "__main__":
    main()
