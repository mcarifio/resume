#!/usr/bin/env -S just --justfile

# https://just.systems/man/en/

# set shell := ["/usr/bin/env", "python3", "-c"]
# run python as root
# set shell := ["/usr/sbin/sudo", "python3", "-c"]

set positional-arguments

default:
    {{justfile()}} --list

echo *args='':
    echo "$*"


url := "http://mike.carif.io/resume/"
host := "www-data@do"
folder := "html/mike.carif.io/html/resume"
scp := "{{host}}:{{folder}}"

browse:
    xdg-open {{url}}  &> /dev/null

gpps:
    gpp -o mike-carifio.md mike-carifio.gpp.md
    gpp -Dfull -o mike-carifio-full.md mike-carifio.gpp.md

html5: gpps
    pandoc --standalone --to=html5 

docxs: gpps

pdfs: gpps
    
	
html5: gpp
	pandoc --standalone --to=html5 $< -o $@

