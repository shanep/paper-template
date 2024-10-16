PROCEDINGS := tbd
PAPER_ID := 00
TAPS := $(PROCEDINGS)-$(PAPER_ID)

%.pdf: %.tex
	latexmk -pdf -cd $<

FIGURE_DIR := figures
FIGURE_SRC := $(wildcard $(FIGURE_DIR)/*.tex)
FIGURES := $(FIGURE_SRC:.tex=.pdf)

all: $(FIGURES) paper

paper: paper.pdf

# Create a zip file for the TAPS submission
taps: paper
	mkdir -p $(TAPS)/pdf
	mkdir -p $(TAPS)/source/figures
	cp paper.pdf $(TAPS)/pdf/
	cp paper.tex $(TAPS)/source/
	cp paper.bib $(TAPS)/source/
	cp paper.bbl $(TAPS)/source/
	cp figures/*.pdf $(TAPS)/source/figures/
	zip -r $(TAPS).zip $(TAPS)/

arxiv: paper
	mkdir -p arxiv/figures/
	cp paper.tex arxiv
	cp paper.bib arxiv
	cp paper.bbl arxiv
	cp figures/*.pdf arxiv/figures/
	zip -r arxiv.zip arxiv/

checkcites: paper
	checkcites --unused $^

.PHONY: clean
clean:
	cd $(FIGURE_DIR) && latexmk -c; rm -f *.synctex.gz && cd ..
	latexmk -C; rm -f *.bbl
