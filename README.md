# CTS-Backend


## Install Rust

Follow the instructions on https://doc.rust-lang.org/book/ch01-01-installation.html

## Docker

View the `Dockerfile` for specfics.

To build the image:
```sh
$ docker build -t f7-cts-backend:latest --no-cache .
```

To deploy the image using the docker environment:
```sh
$ docker run -i -t f7-cts-backend:latest -p 8080:8080 --name f7-cts-backend /bin/bash 
```

To shutdown and/or delete the container, refer to these commands:


## 



# Troubleshooting
Section for any encountered problems and their (temporary) fixes.

### 01: Git hooks using 'Rusty Hook' under Windows
Initialization may not create the necessary hook files.
Manually create files `.git/hooks/{pre-commit, pre-push}` and enter cargo commands to run.