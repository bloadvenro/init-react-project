cat << EOF > $ROOT/babel.config.js
const isTestEnv = process.env.NODE_ENV === 'test';

module.exports = {
  presets: [
    [
      '@babel/preset-env',
      {
        modules: isTestEnv
          ? 'commonjs' // transform imports for jest to work
          : false, // do not transform imports to allow tree shaking by webpack
      },
    ],
    '@babel/preset-react',
    '@babel/preset-typescript',
  ],
};
EOF