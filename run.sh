#!/bin/bash

function printtime {
    START=$(date +%s)
    "$@"
    END=$(date +%s)
    DIFF=$(echo "$END - $START" | bc)
    echo -e "\033[97;48;5;21m ${DIFF} seconds\x1B[K\033[0m\n"
}

function colorecho {
    echo -e "\033[30;48;5;82m $1 \x1B[K\033[0m"
}


function runTest {
  pushd $1

    colorecho "### $1: removing old containers"
    printtime docker-compose down -v || true

    colorecho "### $1: starting container"
    printtime docker-compose up -d --force

    colorecho "### $1: remove old drupal folder"
    printtime docker-compose exec --user drupal drupal bash -c 'chmod -R +w drupal && rm -rf drupal'

    colorecho "### $1: composer create project"
    printtime docker-compose exec --user drupal drupal bash -c 'composer create-project amazeeio/drupal-project:8.x-dev drupal --no-interaction'

    colorecho "### $1: drush site install 3x"
    for i in `seq 1 3`;
    do
        printtime docker-compose exec --user drupal drupal bash -c 'cd ~/public_html/drupal/web && drush -y si --account-name=blub --account-mail=bla@bla.com'
    done


    colorecho "### $1: drush cr 3x"
    for i in `seq 1 3`;
    do
        printtime docker-compose exec --user drupal drupal bash -c 'cd ~/public_html/drupal/web && drush -y cr'
    done

    colorecho "### $1: removing containers"
    printtime docker-compose down -v || true

  popd
}

colorecho "### CACHALOT"
# Loading env variables so that we use Cachalot (Docker Machine)
eval $(amazeeio-cachalot env)

runTest cachalot

# Removing Cachalot Docker Environment Variables again, now we use Docker for Mac
# see https://docs.docker.com/docker-for-mac/docker-toolbox/
unset ${!DOCKER_*}

colorecho "### Docker for Mac - delegated"
runTest delegated

colorecho "### Docker for Mac - cached"
runTest cached

colorecho "### Docker for Mac - consistent"
runTest consistent
