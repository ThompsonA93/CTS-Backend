# CTS-Backend

## Rust

Follow the instructions on https://doc.rust-lang.org/book/ch01-01-installation.html

#### Cargo
Cargo is the package manager of Rust.

Refer to `Cargo.toml` for details.

## Docker

View the `Dockerfile` for specfics on the image.
View the `docker-compose.yaml` for deployment details.


#### Commands
To build the image:
```sh
$ docker build -t f7-cts-backend:latest --no-cache .
```

To deploy the image using the docker environment:
```sh
$ docker run -i -t f7-cts-backend:latest -p 8080:8080 --name f7-cts-backend /bin/bash 
```

## CircleCI

Refer to `.circleci/config.yml`
















# Troubleshooting
Section for any encountered problems and their (temporary) fixes.

### 01: Git hooks using 'Rusty Hook' under Windows
Git hooks is not officially supported under windows. Required workaround using manual shell-scripts
Manually create files `.git/hooks/{pre-commit, pre-push}` and enter cargo commands to run.
```sh
# .git\hooks\pre-commit
#!/bin/bash
cp ./Dockerfile ./.circleci/images/primary/Dockerfile
cargo check
cargo build --release

# .git\hooks\pre-push
#!/bin/bash
cargo test --release
docker compose build --no-cache
```
### 02: 'invalid reference format: repository name (images/primary/Dockerfile) must be lowercase'
