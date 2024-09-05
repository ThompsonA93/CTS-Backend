# CTS-Backend

## Rust

Follow the instructions on https://doc.rust-lang.org/book/ch01-01-installation.html to install RustC on your local device or containers.

#### Cargo
Cargo is the package manager of Rust.

`Cargo.toml` contains the specification of the project.

Install and build the project by debug (non-optimized for dependencies) or by release (optimized, longer build durations).
```sh
$ cargo build (--release)
$ cargo test (--release)
```
Execute the programm using cargo or target executable.
```sh
$ cargo run
$ ./target/release/f7-cts-backend.exe
```
*Note*: The executable works under windows and linux (WSL).

Publishing of the software can be done via API-Token or login
```sh
$ cargo publish --token ${CARGO_API_TOKEN}
$ cargo login && cargo publish
```


## Docker

Install Docker Desktop on the machine following the instructions at https://docs.docker.com/desktop/install/windows-install/.


View the `Dockerfile` for specfics on the image.
View the `docker-compose.yaml` for deployment details.

Build and deploy the image given the Dockerfile.
```sh
$ docker build -t thompsona93/cts-backend . (--no-cache)
$ docker run thompsona93/cts-backend --p 8080:8080 (-d)
```

Alternatively use the docker compose files supplied.
```sh
$ docker compose up --detach
$ docker compose down
```

Publish the containerized image to Dockerhub.
```sh
$ docker login
$ docker push thompsona93/cts-backend:0.1
```




## CircleCI

`.circleci/config.yml` contains the CI/CD pipeline, which deploys the Software-Artifact to Cargo, which can be viewed here: https://crates.io/crates/f7-cts-backend




## Google Kubernetes Engine

Setup Google Cloud with your profile.

Create the project and fetch the project's ID.

Use the Browser-CLI or install a local CLI for Cloud connections.

Set defaults for gcloud
```sh
gcloud config set project PROJECT_ID
gcloud config set compute/zone eu-west-d 
```

Manage Clusters:
```sh
gcloud container clusters list
gcloud container clusters create <NAME>
gcloud container clusters delete <NAME>
```


Create the clusters. Given the requirements of the software, creating a cluster in each of the target regions will significantly boost latency for each player within the given country.
Setup of a singular K8s cluster can be achieved as follows.
```sh
# Deploy Cluster to fit F7 requirements: North America, Europe and Asia
# Note: additional-zones is deprecated
gcloud container clusters create f7-cts-backend-cluster-us --zone us-central1-a
gcloud container clusters create f7-cts-backend-cluster-eu --zone europe-central2-a
gcloud container clusters create f7-cts-backend-cluster-as --zone asia-east2-a
```

For each of these clusters, the application must be loaded and deployed with varying resources. Notable flags following https://cloud.google.com/sdk/gcloud/reference/container/clusters/create :
- num-nodes
- disk-size
- max-cpu, min-cpu
- max-memory, min-memory
- enable-autoscaling
- monitoring
- enable-cloud-monitoring

-- TODO continuation of deploying Github to Google Kubernetes Cluster following https://docs.github.com/en/actions/use-cases-and-examples/deploying/deploying-to-google-kubernetes-engine 





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
### 02: invalid reference format: repository name (images/primary/Dockerfile) must be lowercase
Workaround using CircleCIs container of cmg/rust:latest

### 03: error: failed to create deployment: the server could not find the requested resource (post deployments.apps)
Workaround using standard images and installation within them.