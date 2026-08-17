import os
from PIL import Image, ImageOps

# Diretório de origem (atual) e destino (mini)
SOURCE_DIR = "/home/brunofs/Pictures/homepage"
OUTPUT_DIR = os.path.join(SOURCE_DIR, "mini")

# Largura/Altura máxima para a thumbnail (mantém a proporção)
MAX_SIZE = (400, 400)
QUALITY = 85

VALID_EXTENSIONS = ('.jpg', '.jpeg', '.png', '.webp', '.bmp', '.tiff')

def create_thumbnails():
    if not os.path.exists(OUTPUT_DIR):
        os.makedirs(OUTPUT_DIR)
        print(f"Diretório '{OUTPUT_DIR}' criado.")

    files = os.listdir(SOURCE_DIR)
    processed_count = 0

    for filename in files:
        if filename.lower().endswith(VALID_EXTENSIONS):
            input_path = os.path.join(SOURCE_DIR, filename)
            output_path = os.path.join(OUTPUT_DIR, filename)

            try:
                with Image.open(input_path) as img:
                    # Preserva a orientação EXIF se existir
                    img = ImageOps.exif_transpose(img)
                    
                    # Redimensiona mantendo a proporção de aspecto
                    img.thumbnail(MAX_SIZE, Image.Resampling.LANCZOS)
                    
                    # Converte para RGB se estiver em RGBA (para salvar em JPG/JPEG sem erro)
                    if img.mode in ("RGBA", "P") and filename.lower().endswith(('.jpg', '.jpeg')):
                        img = img.convert("RGB")

                    img.save(output_path, quality=QUALITY, optimize=True)
                    print(f"Processada: {filename} -> {output_path}")
                    processed_count += 1
            except Exception as e:
                print(f"Erro ao processar {filename}: {e}")

    print(f"\nConcluído! {processed_count} imagens foram processadas e salvas em '{OUTPUT_DIR}'.")

if __name__ == "__main__":
    create_thumbnails()
