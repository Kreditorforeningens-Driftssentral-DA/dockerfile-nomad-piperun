# NOMAD PIPERUN (DOCKERFILE)

## DESCRIPTION

[Ubuntu](https://hub.docker.com/_/ubuntu) image, with [HashiCorp Nomad](https://www.nomadproject.io/) binary added via apt.
For use in docker-pipelines; example when running nomad commands.
Image-versioning follows the nomad binary versions

#### NOTE:
You can build a smaller image (~180MB) using 'Dockerfile.multistage' as a template if you want to keep image-size at a minimum.
This image is built using apt-repo for improved 'readability'

```bash
# Example, using custom image & version
IMAGE=clearlinux:latest
VERSION=1.0.0-beta3
docker build \
  --build-arg RUNTIME_IMAGE=${IMAGE} \
  --build-arg HASHICORP_NOMAD_RELEASE=${VERSION} \
  -t nomad-${VERSION}/${IMAGE} \
  -f Dockerfile.multistage .

# Validate version
docker run --rm -it nomad-${VERSION}/${IMAGE}

# Example build artifacts:
#REPOSITORY                 TAG       IMAGE ID       CREATED              SIZE
#nomad-1.0.0-beta3/clearlinux   latest    785c3b3d6806   30 seconds ago   281MB
#nomad-1.0.0-beta3/ubuntu       latest    892678f251b9   5 minutes ago    181MB
#nomad-1.0.0-beta3/centos       latest    3af41767c2bb   6 minutes ago    323MB 
#nomad-1.0.0-beta3/fedora       latest    a20dd4072176   10 minutes ago   283MB
```

## RELATED LINKS

* Source code on [GitHub](https://www.github.com/Kreditorforeningens-Driftssentral-DA/dockerfile-nomad-piperun)
* Image on [Docker hub](https://hub.docker.com/r/kdsda/nomad-piperun)

## USAGE

```bash
# Build local image (testing)
# See 'Makefile' for info
$ make build
```

```bash
# docker run --rm -it -e NOMAD_ADDR=<nomad-address> -NOMAD_TOKEN=<nomad-token> kdsda/nomad-piperun:v0.12.8 <command>
# Example:
$ docker run --rm -it -e NOMAD_ADDR=http://10.0.0.100:4646 kdsda/nomad-piperun:v0.12.8 status
```

## OTHER USE-CASES

You can also run nomad as client/server with this image (testing purposes)

```bash
# Start Nomad in dev-mode, with docker socket assigned
# Access UI: http://localhost:4646
docker run \
  --rm -it \
  --user=root --privileged \
  --name nomad-piperun \
  -p 4646:4646 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  kdsda/nomad-piperun:edge \
    agent -dev -bind 0.0.0.0 -network-interface eth0
```

Example job
```hcl2
# NOTE: port not exposed 'externally'
job "demo" {
  datacenters = ["dc1"]
  group "demo" {
    network {
      mode = "host"
      port "http" {
        static = 8080
        to = 80
      }
    }
    task "demo" {
      driver = "docker"
      config {
        image = "nginx:alpine"
      }
    }
  }
}
```
