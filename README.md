# Docker Performance Testing

Since Docker 17.04 CE Edge Docker for Mac has new performance tuning capabilities for volume mounts. [Read here](https://docs.docker.com/docker-for-mac/osxfs-caching/)

This script tests the performance of the 3 new volume mount types (delegated, cached, consistent) and the amazee.io cachalot system.

The idea behind is to figure out which of the new volume mount types is the fastest and if it is faster than cachalot.

## Prerequisites

- Installed [cachalot](https://docs.amazee.io/local_docker_development/os_x_cachalot.html)
- Installed [Docker for Mac Edge Channel](https://docs.docker.com/docker-for-mac/install/)
- Installed [pygmy](https://docs.amazee.io/local_docker_development/pygmy.html)

Maybe read [Docker for Mac vs. Docker Toolbox](https://docs.docker.com/docker-for-mac/docker-toolbox/) to learn more about having two Docker installed on the same machine

## Usage

      ./setup.sh
      ./run.sh