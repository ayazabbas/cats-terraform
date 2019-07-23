#!/bin/bash
set -e

# cleanup tmp folder
if [ -d tmp ]
then
    rm -rf tmp
fi
mkdir tmp

cd tmp
git clone https://github.com/Streetbees/cats.git
cd cats
git checkout $TAG
zip -r ../cats.zip *
cd ..
rm -rf cats

terraform apply