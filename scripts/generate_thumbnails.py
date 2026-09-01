"""
generate_thumbnails.py
----------------------
Gera versões reduzidas (thumbnails) das fotos em images/, salvando-as em images/mini/.

Opera de forma incremental: só processa fotos que ainda não têm thumbnail.
Se quiser regenerar uma thumbnail específica, apague o arquivo em images/mini/ e rode novamente.

Por que esse script existe no CI?
  A homepage exibe thumbnails no grid (carregamento rápido) e a foto original
  só no modal. Gerar thumbnails manualmente e commitá-las é trabalho que o CI
  pode absorver: a imagem original entra no repo, o CI gera o mini e deploya tudo.

Uso:
  python scripts/generate_thumbnails.py          # só as que faltam
  python scripts/generate_thumbnails.py --force  # regenera todas
"""

import argparse
from pathlib import Path

from PIL import Image, ImageOps

# ── Configuração ──────────────────────────────────────────────────────────────

IMAGES_DIR  = Path(__file__).parent.parent / "images"
MINI_DIR    = IMAGES_DIR / "mini"
MAX_SIZE    = (400, 400)   # largura/altura máxima; proporção é preservada
QUALITY     = 85
VALID_EXTENSIONS = {".jpg", ".jpeg"}


# ── Execução principal ────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(
        description="Gera thumbnails das fotos em images/mini/."
    )
    parser.add_argument(
        "--force",
        action="store_true",
        help="Regenera thumbnails mesmo para fotos que já as possuem.",
    )
    args = parser.parse_args()

    MINI_DIR.mkdir(exist_ok=True)

    image_files = sorted(
        p for p in IMAGES_DIR.iterdir()
        if p.is_file() and p.suffix.lower() in VALID_EXTENSIONS
    )

    processed = 0
    skipped   = 0

    for src in image_files:
        dest = MINI_DIR / src.name

        if not args.force and dest.exists():
            skipped += 1
            continue

        try:
            with Image.open(src) as img:
                # Corrige orientação EXIF antes de redimensionar
                img = ImageOps.exif_transpose(img)
                img.thumbnail(MAX_SIZE, Image.Resampling.LANCZOS)

                # JPG não suporta canal alpha — converte se necessário
                if img.mode in ("RGBA", "P") and src.suffix.lower() in (".jpg", ".jpeg"):
                    img = img.convert("RGB")

                img.save(dest, quality=QUALITY, optimize=True)
                print(f"  ✓  {src.name}")
                processed += 1

        except Exception as e:
            print(f"  ⚠  {src.name}: {e}")

    if skipped:
        print(f"  —  {skipped} thumbnail(s) já existente(s), ignorada(s).")

    print(f"\n✓ {processed} thumbnail(s) gerada(s) em {MINI_DIR}")


if __name__ == "__main__":
    main()
