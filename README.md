[![Makefile CI](https://github.com/rzuckerm/phix-docker-images/actions/workflows/makefile.yml/badge.svg)](https://github.com/rzuckerm/phix-docker-images/actions/workflows/makefile.yml)
[![Docker](https://github.com/rzuckerm/phix-docker-images/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/rzuckerm/phix-docker-images/actions/workflows/docker-publish.yml)

# phix-docker-images

Docker images for [Phix programming language](http://phix.x10.mx/):

- rzuckerm/phix:`<version>-<os>-<tag>` - Phix without `gcc` compiler
- rzuckerm/phix:`<version>-<os>-gcc-<tag>` - Phix with `gcc` compiler

where:

- `<version>` is the [Phix version](PHIX_VERSION)
- `<os>` is the Operating System (currently only Ubuntu 22.04)
- `<tag>` is the current GitHub tag without the "v"
