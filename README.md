# dockerfile-nomad-piperun

Ubuntu with HashiCorp Nomad binary added. For use in docker-pipelines when running nomad commands

## USAGE

```bash
# Build:
$ make build
```

```bash
# docker run --rm -it -e NOMAD_ADDR=<nomad-address> -NOMAD_TOKEN=<nomad-token> nomad:piperun <command>
# Example:
$ docker run --rm -it -e NOMAD_ADDR=http://10.0.0.100:4646 nomad:piperun status
```
