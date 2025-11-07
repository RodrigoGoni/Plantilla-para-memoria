rm -f *.aux *.out *.bbl *.blg *.log *.toc *.lof *.lot *.run.xml
pdflatex -interaction=nonstopmode memorianueva
bibtex memorianueva
pdflatex -interaction=nonstopmode memorianueva && pdflatex -interaction=nonstopmode memorianueva