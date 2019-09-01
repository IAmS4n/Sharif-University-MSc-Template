# set latexfile to the name of the main file without the .tex
latexfile = Thesis
 
# Use this line, if you want to use latex command
# TEX = latex -interaction=nonstopmode --src-specials
# Use this line, if you want to use pdflatex command
#TEX = pdflatex -interaction=nonstopmode --shell-escape --src-specials
 TEX = xelatex --shell-escape --src-specials
 .PHONY : clean

all : $(latexfile).pdf $(latexfile).aux
 
clean:
	rm -f *.aux *.log *.dvi $(latexfile).ps *.bak $(latexfile).ps.gz $(latexfile).ps.bz2
	rm -f *.bbl *.blg
	rm -f *.toc *.lof *.lot
	rm -f *.thm *.out
	rm -f *.ind *.idx *.ilg
 
#$(latexfile).aux : $(latexfile).tex
#	$(TEX) $(latexfile)

# reruns latex if needed.  to get rid of this capability, delete the
# three lines after the rule.  Delete .bbl dependency if not using
# BibTeX references.
# idea from http://ctan.unsw.edu.au/help/uk-tex-faq/Makefile
$(latexfile).pdf : $(latexfile).tex $(latexfile).bbl $(latexfile).blg $(latexfile).toc index
	while ($(TEX) $(latexfile) ; \
	grep -q "Rerun to get cross" $(latexfile).log ) do true ; \
	done
 
$(latexfile).toc $(latexfile).aux: $(latexfile).tex
	$(TEX) $(latexfile)
 
$(latexfile).bbl  $(latexfile).blg: $(latexfile).aux
	bibtex $(latexfile)
 
%.bbl: %.aux \
	bibtex $(basename $<)
 
index : $(latexfile).glo
 
$(latexfile).glo : $(latexfile).aux
	makeglossaries $(latexfile)