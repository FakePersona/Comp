all: smart dumb

dumb: dumb.ml
	ocamlc -pp "camlp4o" dumb.ml -o dumb

smart: smart.ml
	ocamlc -pp "camlp4o" smart.ml -o smart

rapport.pdf: rapport/rapport.tex
	cd rapport/
	pdflatex  rapport/rapport.tex
	cd ..

clean:
	rm -rf *.cm* *.aux *.log
