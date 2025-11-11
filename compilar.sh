#!/bin/bash

# Eliminar TODOS los archivos auxiliares
rm -f *.aux *.bbl *.blg *.out *.toc *.lof *.lot *.bcf *.run.xml *.log *.synctex.gz
rm -f Chapters/*.aux
rm -f portada.aux
rm -f *.aux *.bbl *.blg *.log *.out *.toc *.lof *.lot *.run.xml Chapters/*.aux
# Compilar
pdflatex -interaction=nonstopmode memorianueva
bibtex memorianueva
pdflatex -interaction=nonstopmode memorianueva
pdflatex -interaction=nonstopmode memorianueva