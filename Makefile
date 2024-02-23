# https://www.gnu.org/software/make/manual/html_node/Automatic-Variables.html
%.md : %.gpp.md
	gpp -o $@ $<

%.yaml : %.gpp.yaml
	gpp -o $@ $<

%..md.html : %..md
	pandoc --standalone --to=html5 $< -o $@

%.md.docx : %.md
	pandoc --standalone --to=docx $< -o $@

%.md.pdf : %.md
	pandoc --standalone --pdf-engine=wkhtmltopdf  --to=html $< -o $@

%.contact.yaml.vcf : %.contact.yaml
	touch $@

%.mdx.js : %.mdx
	./mdx.ts $<

rwildcard=$(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2) $(filter $(subst *,%,$2),$d))


GPP := $(call rwildcard, src,*.gpp.md)
YAML := $(call rwildcard, src,*.yaml)
SOURCES := $(GPP) $(YAML)
# MDS := mike-carifio.md mike-carifio-full.md
USERNAME_HOSTNAME := www-data@do
FOLDER := html/mike.carif.io/html/resume
SCP := $(USERNAME_HOSTNAME):$(FOLDER)
URL := http://mike.carif.io/resume/
SUFFIX := md html pdf docx
OUT := out
RESUME=$(OUT)/resume
OBJECTS := $(foreach source, $(SOURCES), $(foreach suffix,$(SUFFIX), $(RESUME)/$(source).$(suffix)))

.PSEUDO: all clean start objects sources upload browse ssh gitignore
all : objects
objects: $(OBJECTS)
$(OBJECTS) : $(SOURCES)

# mike-carifio.md : mike-carifio.gpp.md
# 	gpp -o $@ $<

# mike-carifio-full.md : mike-carifio.gpp.md
# 	gpp -Dfull -o $@ $<


clean :
	rm -rf $(RESUME)

# TODO mike@carif.io: overwriting index.hml
# rsync -avz --backup --backup-dir=.attic --relative --exclude='.git*' for/ testimonials/ $(SOURCES) $(OBJECTS) $(SCP)
# rsync -avz --exclude='.git*' $(SOURCES) $(OBJECTS) $(SCP)
# rsync -avz --exclude='.git*' --relative for/ $(SCP)
# rsync -avz --exclude='.git*' --relative testimonials/ $(SCP)

upload: objects
	rsync -avz --relative --exclude='.git*' $(RESUME)/ $(SCP)

browse: upload
	xdg-open $(URL)


start:
	sudo dnf install -y pandoc wkhtmltopdf just curl deno direnv gpp
	direnv allow .

ssh:
	ssh $(USERNAME_HOSTNAME) ## cd $(FOLDER)

gitignore:
	@printf '*.%s\n' $(SUFFIX)
	@printf '%s/**\n' $$(realpath --relative-to=. -m $(OUT))

