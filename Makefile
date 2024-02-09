# https://www.gnu.org/software/make/manual/html_node/Automatic-Variables.html
%.md.html : %.md
	pandoc --standalone --to=html5 --metadata title="Mike Carifio" $< -o $@

%.md.docx : %.md
	pandoc --standalone --to=docx $< -o $@

%.md.pdf : %.md
	pandoc --standalone --pdf-engine=wkhtmltopdf  --to=html --metadata title="Mike Carifio" $< -o $@

%.contact.yaml.vcf : %.contact.yaml
	touch $@

%.mdx.js : %.mdx
	./mdx.ts $<


SOURCES := mike-carifio.md mike-carifio.mdx mike-carifio.contact.yaml
OBJECTS := mike-carifio.md.html mike-carifio.md.docx mike-carifio.md.pdf mike-carifio.contact.yaml.vcf mike-carifio.mdx.js
SCP := www-data@do:html/mike.carif.io/html/resume
URL := http://mike.carif.io/resume/

.PSEUDO: all clean start objects sources upload browse
all : objects
objects: $(OBJECTS) # prereq
$(OBJECTS) : $(SOURCES)

clean :
	rm $(OBJECTS)

upload: objects
	rsync -av --exclude='.git*' for/ testimonials/ $(SOURCES) $(OBJECTS) $(SCP)

browse: upload
	xdg-open $(URL)


start:
	sudo dnf install -y pandoc wkhtmltopdf just curl deno direnv
	direnv allow .



