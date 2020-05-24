cat << EOF > $ROOT/.lintstagedrc.es.json
{
  "*.{js,ts,tsx}": "eslint --fix",
}
EOF

cat << EOF > $ROOT/.lintstagedrc.test.json
{
  "*.{ts,tsx}": "jest --findRelatedTests"
}
EOF