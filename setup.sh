#!/bin/bash

function setupCache {
  echo "### warming composer-cache to be mounted into docker containers"
  chmod -R +w composer-cache drupal
  rm -rf composer-cache drupal
  mkdir -p composer-cache drupal

  mkdir -p composer-cache
  COMPOSER_CACHE_DIR=$PWD/composer-cache composer create-project amazeeio/drupal-project:8.x-dev drupal --no-interaction &> /dev/null
}

setupCache