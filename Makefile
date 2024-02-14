# https://www.gnu.org/software/make/manual/html_node/Automatic-Variables.html
%.md : %.gpp.md
	gpp -o $@ $<

%.md.html : %.md
	pandoc --standalone --to=html5 $< -o $@

%.md.docx : %.md
	pandoc --standalone --to=docx $< -o $@

%.md.pdf : %.md
	pandoc --standalone --pdf-engine=wkhtmltopdf  --to=html $< -o $@

%.contact.yaml.vcf : %.contact.yaml
	touch $@

%.mdx.js : %.mdx
	./mdx.ts $<


SOURCES := mike-carifio.gpp.md mike-carifio.mdx mike-carifio.contact.yaml
MDS := mike-carifio.md mike-carifio-full.md
HOST := www-data@do
FOLDER := html/mike.carif.io/html/resume
SCP := $(HOST):$(FOLDER)
URL := http://mike.carif.io/resume/
SUFFIX := html pdf docx
OBJECTS := $(foreach s,$(SUFFIX), mike-carifio.md.$(s)) $(foreach s,$(SUFFIX), mike-carifio-full.md.$(s)) mike-carifio.contact.yaml.vcf mike-carifio.mdx.js

.PSEUDO: all clean start objects sources upload browse ssh
all : $(MDS) objects

mike-carifio.md : mike-carifio.gpp.md
	gpp -o $@ $<

mike-carifio-full.md : mike-carifio.gpp.md
	gpp -Dfull -o $@ $<

objects: $(OBJECTS) # prereq
$(OBJECTS) : $(SOURCES)

clean :
	rm $(OBJECTS)

# TODO mike@carif.io: overwriting index.hml
# rsync -avz --backup --backup-dir=.attic --relative --exclude='.git*' for/ testimonials/ $(SOURCES) $(OBJECTS) $(SCP)
# rsync -avz --exclude='.git*' $(SOURCES) $(OBJECTS) $(SCP)
# rsync -avz --exclude='.git*' --relative for/ $(SCP)
# rsync -avz --exclude='.git*' --relative testimonials/ $(SCP)

upload: objects
	rsync -avz --relative --exclude='.git*' for/ testimonials/ publications/ $(SOURCES) $(OBJECTS) $(SCP)

browse: upload
	xdg-open $(URL)


start:
	sudo dnf install -y pandoc wkhtmltopdf just curl deno direnv gpp
	direnv allow .

ssh:
	ssh $(HOST) ## cd $(FOLDER)


