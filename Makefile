# https://www.gnu.org/software/make/manual/html_node/Automatic-Variables.html
%.md.html : %.md
	pandoc --standalone --to=html5 --metadata title="Mike Carifio" $< -o $@

%.md.docx : %.md
	pandoc --standalone --to=docx $< -o $@

%.md.pdf : %.md
	pandoc --standalone --pdf-engine=wkhtmltopdf  --to=html --metadata title="Mike Carifio" $< -o $@

%.contact.yaml.vcf : %.contact.yaml
	echo "tbs $< -> $@"


SOURCES := mike-carifio.md mike-carifio.contact.yaml
OBJECTS := mike-carifio.md.html mike-carifio.md.docx mike-carifio.md.pdf mike-carifio.contact.yaml.vcf
SCP := www-data@do:html/mike.carif.io/html/resume
URL := http://mike.carif.io/resume/

.PSEUDO: all clean prereq objects sources scp browse
all : objects
objects: $(OBJECTS) # prereq
$(OBJECTS) : $(SOURCES)

clean :
	rm $(OBJECTS)

scp: objects
	scp $(SOURCES) $(OBJECTS) $(SCP)

browse: scp
	xdg-open $(URL)


# TODO mike@carif.io: have make install the right tools before all
prereq: /usr/bin/pandoc /usr/bin/wkhtmltopdf
	sudo dnf install -y pandoc mkhtmltopdf just



