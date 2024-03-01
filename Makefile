# https://stackoverflow.com/questions/16467718/how-to-print-out-a-variable-in-makefile
# if the first command line argument is "print"
# ifeq ($(firstword $(MAKECMDGOALS)),print)

#   # take the rest of the arguments as variable names
#   VAR_NAMES := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))

#   # turn them into do-nothing targets
#   $(eval $(VAR_NAMES):;@:))

#   # then print them
#   .PHONY: print
#   print:
#           @$(foreach var,$(VAR_NAMES),\
#             echo '$(var) = $($(var))';)
# endif

rwildcard=$(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2) $(filter $(subst *,%,$2),$d))
HERE := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))


SRC := src
GPP := $(call rwildcard, $(SRC),*.md)
YAML := $(call rwildcard, $(SRC),*.yaml)
SOURCES := $(GPP) $(YAML)
$(info $(SOURCES))
# MDS := mike-carifio.md mike-carifio-full.md
USERNAME_HOSTNAME := www-data@do
FOLDER := html/mike.carif.io/html/resume
SCP := $(USERNAME_HOSTNAME):$(FOLDER)
URL := http://mike.carif.io/resume/
SUFFIX := md html pdf docx
OUT := out
RESUME=$(OUT)/resume
OBJECTS := $(foreach source, $(SOURCES), $(foreach suffix,$(SUFFIX), $(RESUME)/$(source).$(suffix)))
$(info $(OBJECTS))

# https://www.gnu.org/software/make/manual/html_node/Automatic-Variables.html
# vpath %.gpp.md $(SRC)
$(RESUME)/%.gpp.md : $(SRC)/%.gpp.md
	gpp -o $@ $^

# vpath %.gpp.yaml $(SRC)
$(RESUME)/%.yaml : $(SRC)/%.yaml
	cp -v $^ $@

# vpath %.md $(RESUME)
$(RESUME)/%.gpp.md.html : $(RESUME)/%.gpp.md
	pandoc --standalone --to=html5 $^ -o $@

# vpath %.md $(RESUME)
$(RESUME)/%.gpp.md.docx : $(RESUME)/%.gpp.md
	pandoc --standalone --to=docx $^ -o $@

$(RESUME)/%.gpp.md.pdf : $(RESUME)/%.gpp.md
	pandoc --standalone --pdf-engine=wkhtmltopdf  --to=html $^ -o $@

# vpath %.contact.yaml $(SRC)
$(RESUME)/%.contact.yaml.vcf : $(SRC)/%.contact.yaml
	cp -v $^ $@

vpath %.mdx $(SRC)
$(RESUME)/%.mdx.js : $(SRC)/%.mdx
	./mdx.ts $@



.PSEUDO: all clean start objects sources upload browse ssh make.gitignore
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

gitignore : Makefile
	printf  '\n\n# $@ generated with `$@` on %s\n' "$$(date)" >> $<
	printf '*.%s\n' $(SUFFIX) >> $<
	printf '%s/**\n' $$(realpath --relative-to=. -m $(OUT)) >> $<
