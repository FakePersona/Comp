all: expr

expr: dumb.ml
	ocamlc -pp "camlp4o" dumb.ml -o dumb

rapport.pdf: rapport/rapport.tex
	cd rapport/
	pdflatex  rapport/rapport.tex
	cd ..

clean:
	rm -rf *.cm* *.aux *.log
