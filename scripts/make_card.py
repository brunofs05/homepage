"""
make_card.py
------------
Gera a capa de um card (cursos, projetos) a partir de qualquer imagem: escreve
images/cards/<slug>.jpg, quadrada, pequena e sempre no mesmo padrão.

Convenção: o slug é o nome da página do card, o mesmo de <seção>/<slug>.typ.
  Ex: projects/egpu.typ → images/cards/egpu.jpg
Por isso o slug precisa ser único entre todas as seções.

Por que 200x200?
  O .card-thumb no CSS tem 100x100 px. Guardamos 2x para telas de alta densidade
  (retina); mais que isso é bytes desperdiçados.

Como o recorte funciona:
  ImageOps.fit redimensiona e corta no centro até a proporção 1:1 (equivale ao
  object-fit: cover do CSS, mas feito uma vez só, em vez de o browser baixar a
  imagem grande e descartar o excesso).

Transparência:
  JPEG não tem canal alfa. PNGs com fundo transparente são achatados sobre branco.

Original:
  Não é alterado nem apagado; pode ficar onde estiver (ex: ~/Downloads).
  Rodar de novo com o mesmo slug substitui a capa.

Uso:
  .venv/bin/python scripts/make_card.py ~/Downloads/foto.png egpu
"""

import argparse
from pathlib import Path

from PIL import Image, ImageOps

ROOT    = Path(__file__).parent.parent
OUT_DIR = ROOT / "images" / "cards"
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
    parser = argparse.ArgumentParser(description="Gera a capa 200x200 de um card.")
    parser.add_argument("source", type=Path, help="imagem de origem (jpg, png, webp)")
    parser.add_argument("slug", help="nome da página do card, ex: egpu")
    args = parser.parse_args()

    if args.source.suffix.lower() not in VALID_EXTENSIONS:
        parser.error(f"formato não suportado: {args.source.suffix} (use {', '.join(sorted(VALID_EXTENSIONS))})")

    OUT_DIR.mkdir(exist_ok=True)
    dest = OUT_DIR / f"{args.slug}.jpg"

    with Image.open(args.source) as img:
        thumb = ImageOps.fit(to_rgb(img), SIZE, Image.Resampling.LANCZOS)
        thumb.save(dest, "JPEG", quality=QUALITY, optimize=True)

    print(f"gerado: {dest.relative_to(ROOT)} ({dest.stat().st_size // 1024} KB)")


if __name__ == "__main__":
    main()
