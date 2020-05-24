cd $ROOT

git init

cat << EOF > .gitignore
.cache
dist
coverage
node_modules
yarn-error.log
EOF

cd -