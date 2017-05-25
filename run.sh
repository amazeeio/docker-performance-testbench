#!/bin/bash

function printtime {
    START=$(date +%s)
    "$@"  &> /dev/null
    END=$(date +%s)
    DIFF=$(echo "$END - $START" | bc)
    echo "$DIFF seconds"
}


function runTest {
  pushd $1

    echo "### $1: starting container"
    printtime docker-compose up -d --force

    echo "### $1: drush site install 5x"
    for i in `seq 1 5`;
    do
        printtime docker-compose exec -T --user drupal drupal bash -c 'cd ~/public_html/web && drush -y si --account-name=blub --account-mail=bla@bla.com'
    done


    echo "### $1: drush cr 5x"
    for i in `seq 1 5`;
    do
        printtime docker-compose exec -T --user drupal drupal bash -c 'cd ~/public_html/web && drush -y cr'
    done

  popd
}

echo "### CACHALOT"
eval $(amazeeio-cachalot env)

runTest cachalot


unset ${!DOCKER_*}

echo "### Docker for Mac - delegated"
runTest delegated

echo "### Docker for Mac - cached"
runTest cached

echo "### Docker for Mac - consistent"
runTest consistent
