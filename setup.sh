#!/bin/bash

function createFolder {
  chmod -R +w $1
  rm -rf $1
  mkdir -p $1

  echo "### composer create-project in $1"
  composer create-project amazeeio/drupal-project:8.x-dev $1 --no-interaction &> /dev/null
}

function setupDockerCompose {
  echo "### changing docker-compose.yml hostname to $1"
  sed -i -e "s/changeme.docker.amazee.io/$1.docker.amazee.io/" $1/docker-compose.yml
}

function configureMountType {
  echo "### changing docker-compose.yml to use $1 volume mount"
  sed -i -e "s/changeme.docker.amazee.io/$1.docker.amazee.io/" $1/docker-compose.yml
  sed -i -e "s/.:\/var\/www\/drupal\/public_html$/.:\/var\/www\/drupal\/public_html:$1/" $1/docker-compose.yml
}

for i in cachalot cached consistent delegated; do
  createFolder $i
  setupDockerCompose $i
done

for i in cached consistent delegated; do
  configureMountType $i
done