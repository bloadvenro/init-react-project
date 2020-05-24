#! /bin/env bash

DIRNAME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

export ROOT=`pwd`
export SRC=$ROOT/src
export DOCS=$SRC/docs
export FONTS=$SRC/fonts
export COMPONENTS=$SRC/components
export TEMPLATES=$SRC/templates
export PAGES=$SRC/pages

mkdir -p $SRC $DOCS $FONTS $COMPONENTS $TEMPLATES $PAGES

cd $DIRNAME/scripts

bash babel.sh
bash browserslist.sh
bash commitlint.sh
bash eslint.sh
bash git.sh
bash husky.sh
bash jest.sh
bash lintstaged.sh
bash package.sh
bash paths.sh
bash postcss.sh
bash prettier.sh
bash src.sh
bash typescript.sh
bash webpack.sh

cd $ROOT

yarn

git add .
git commit -m 'chore: initial commit'

yarn start
