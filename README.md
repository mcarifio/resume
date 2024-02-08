# resume

Exercises in generating a resume.

## start

```
echo "104.236.99.3 do mike.carif.io" | sudo tee -a /etc/hosts
ping do
ping mike.carif.io


cat << EOF >> ~/.ssh/config
Host do mike.carif.io
  IdentitiesOnly=yes
  IdentityFile=~/.ssh/keys.d/quad/do_id_rsa
EOF

ssh -T www-data@do id
uid=33(www-data) gid=33(www-data) groups=33(www-data),27(sudo),1000(mcarifio)

ssh -T www-data@do ls -lad html ## note the group ownership
drwxrwxr-x 33 www-data mcarifio 4096 Nov  8 17:39 html

ssh -T www-data@do groups
www-data sudo mcarifio

sudo dnf upgrade -y
sudo dnf install -y pandoc mkhtmltopdf just gmake emacs curl # yq?

curl --head http://mike.carif.io/resume/
HTTP/1.1 200 OK
Server: nginx/1.12.1 (Ubuntu)
Date: Thu, 08 Feb 2024 22:24:28 GMT
Content-Type: text/html
Content-Length: 18356
Last-Modified: Thu, 08 Feb 2024 22:00:16 GMT
Connection: keep-alive
ETag: "65c54ef0-47b4"
Strict-Transport-Security: max-age=63072000; includeSubdomains
X-Frame-Options: DENY
X-Content-Type-Options: nosniff
Accept-Ranges: bytes
```

## hack

```
emacs mike-carifio.md # ...
make browse  # generates results, uploads to http://mike.carif.io/resume/ and browses the target using your default web browser
```

# todo

* Add https let's encrypt key to https://mike.carif.io/. Use caddy as the server?
* Add styling with css via pandoc. Learn css.
* Generate htmx?
* Author in .mdx instead?
* Match the resume presentation to a job posting.



