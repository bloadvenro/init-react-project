cat << EOF > $ROOT/paths.config.js
/**
 * It is useful to have paths configuration module being shared between different js configs such as
 * \`webpack.config.js\`, \`postcss.config.js\`, \`jest.config.js\` and etc.
 */
const pathUtils = require('path');

const paths = {
  root: (...list) => pathUtils.resolve(__dirname, ...list),
  src: (...list) => paths.root('src', ...list),
  dist: (...list) => paths.root('dist', ...list),
};

module.exports = paths;
EOF