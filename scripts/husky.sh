cat << EOF > $ROOT/husky.config.js
module.exports = {
  "hooks": {
    "pre-commit": "yarn validate:precommit",
    "commit-msg": "commitlint -E HUSKY_GIT_PARAMS"
  }
}
EOF