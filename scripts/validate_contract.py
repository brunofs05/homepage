"""
validate_contract.py
--------------------
Valida images/photos.json contra o contrato definido em images/photos-schema.json.

Retorna exit 0 se o JSON for válido.
Retorna exit 1 se houver qualquer violação — o que faz o step de CI falhar
e bloqueia o deploy antes de dados inválidos chegarem à produção.

Por que esse script existe?
  O extract_metadata.py gera o JSON, mas não sabe se o que gerou é correto.
  Esse script é a verificação independente: lê o contrato, lê o dado,
  compara os dois. Se divergirem, o pipeline para aqui.

  É o equivalente de um teste unitário que quebra o PR:
  o erro é detectado no CI, não no browser do usuário.

Uso:
  python scripts/validate_contract.py              # usa os caminhos padrão
  python scripts/validate_contract.py --help       # mostra opções
"""

import argparse
import json
import sys
from pathlib import Path

import jsonschema
from jsonschema import Draft7Validator

# ── Caminhos padrão ───────────────────────────────────────────────────────────

ROOT        = Path(__file__).parent.parent
DATA_FILE   = ROOT / "images" / "photos.json"
SCHEMA_FILE = ROOT / "images" / "photos-schema.json"


# ── Relatório de erros ────────────────────────────────────────────────────────

def describe_error(error: jsonschema.ValidationError) -> str:
    """Formata um erro de validação em linguagem legível.

    jsonschema retorna erros com 'path' (onde no JSON o erro ocorreu)
    e 'message' (o que está errado). Combinamos os dois para uma
    mensagem que aponta direto para o problema.
    """
    # error.absolute_path é uma deque com os índices do JSON onde o erro ocorreu
    # ex: [12, 'aperture'] → registro 12, campo aperture
    path_parts = list(error.absolute_path)

    if not path_parts:
        # Erro na raiz do array (ex: minItems, type do array)
        return f"  raiz: {error.message}"

    record_index = path_parts[0]
    field = path_parts[1] if len(path_parts) > 1 else "(registro inteiro)"
    return f"  registro [{record_index}]  campo '{field}': {error.message}"


# ── Execução principal ────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(
        description="Valida photos.json contra photos-schema.json."
    )
    parser.add_argument(
        "--data",
        type=Path,
        default=DATA_FILE,
        help=f"Caminho para o JSON de dados (padrão: {DATA_FILE})",
    )
    parser.add_argument(
        "--schema",
        type=Path,
        default=SCHEMA_FILE,
        help=f"Caminho para o JSON Schema (padrão: {SCHEMA_FILE})",
    )
    args = parser.parse_args()

    # ── Leitura dos arquivos ──────────────────────────────────────────────────

    if not args.data.exists():
        print(f"✗ Arquivo de dados não encontrado: {args.data}")
        print("  Execute extract_metadata.py antes de validar.")
        sys.exit(1)

    if not args.schema.exists():
        print(f"✗ Schema não encontrado: {args.schema}")
        sys.exit(1)

    data   = json.loads(args.data.read_text(encoding="utf-8"))
    schema = json.loads(args.schema.read_text(encoding="utf-8"))

    # ── Validação ─────────────────────────────────────────────────────────────

    # Draft7Validator coleta todos os erros de uma vez (ao contrário de
    # jsonschema.validate(), que para no primeiro). Melhor para CI: o
    # desenvolvedor vê todos os problemas em uma única rodada.
    validator = Draft7Validator(schema)
    errors    = sorted(validator.iter_errors(data), key=lambda e: list(e.absolute_path))

    if not errors:
        print(f"✓ Contrato válido — {len(data)} registro(s) em conformidade.")
        sys.exit(0)

    # ── Relatório de falha ────────────────────────────────────────────────────

    print(f"✗ Contrato violado — {len(errors)} erro(s) encontrado(s):\n")
    for error in errors:
        print(describe_error(error))

    print(f"\nArquivo validado:  {args.data}")
    print(f"Schema utilizado:  {args.schema}")
    sys.exit(1)


if __name__ == "__main__":
    main()
