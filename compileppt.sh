#!/usr/bin/env bash
# Compila la presentación Beamer ubicada en ppt/ppt.tex
# Uso: ./compileppt.sh          (desde la raíz del proyecto)
#      ./compileppt.sh clean    (limpia auxiliares y compila)

set -e

ROOT="$(cd "$(dirname "$0")" && pwd)"
PPT_DIR="$ROOT/ppt"
TEX_FILE="$PPT_DIR/ppt.tex"
OUT_DIR="$PPT_DIR"

cd "$PPT_DIR"

if [[ "${1:-}" == "clean" ]]; then
    echo "==> Limpiando auxiliares previos..."
    rm -f ppt.aux ppt.log ppt.nav ppt.out ppt.snm ppt.toc ppt.vrb
fi

echo "==> Compilando $TEX_FILE ..."
pdflatex -interaction=nonstopmode -halt-on-error ppt.tex
pdflatex -interaction=nonstopmode -halt-on-error ppt.tex   # segunda pasada para ToC/índices

echo ""
echo "==> Compilación exitosa."
echo "==> PDF generado: $OUT_DIR/ppt.pdf"
