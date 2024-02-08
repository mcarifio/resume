# https://www.gnu.org/software/make/manual/html_node/Automatic-Variables.html
%.md.html : %.md
	pandoc --standalone --to=html5 --metadata title="Mike Carifio" $< -o $@

%.md.docx : %.md
	pandoc --standalone --to=docx $< -o $@

%.md.pdf : %.md
	pandoc --standalone --pdf-engine=wkhtmltopdf  --to=html --metadata title="Mike Carifio" $< -o $@


OBJECTS := carifio.md.html carifio.md.docx carifio.md.pdf

.PSEUDO: all clean prereq
all : $(OBJECTS) # prereq
clean :
	rm $(OBJECTS)

# prereq: /usr/bin/pandoc /usr/bin/wkhtmltopdf
# 	sudo dnf install -y pandoc mkhtmltopdf just

$(OBJECTS) : carifio.md
