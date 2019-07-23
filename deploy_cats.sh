#!/bin/bash
set -e
printf "Enter application version (git tag)...\n"
read VERSION
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
pushd "${DIR}"

# cleanup tmp folder
if [ -d "${DIR}/tmp" ]
then
    printf "Cleaning up tmp folder...\n"
    rm -rf "${DIR}/tmp"
fi
mkdir "${DIR}/tmp"

cd "${DIR}/tmp"
git clone https://github.com/Streetbees/cats.git
cd "${DIR}/tmp/cats"
git checkout "${VERSION}"
zip -r "${DIR}/tmp/cats.zip" *
cd "${DIR}/tmp"
rm -rf cats
cd "${DIR}"

terraform apply -var app_version="${VERSION}"

printf "Cleaning up tmp folder...\n"
rm -rf "${DIR}/tmp"