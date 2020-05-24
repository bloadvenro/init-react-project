cat << EOF > $ROOT/postcss.config.js
/**
 * This module config is used by postcss webpack loader so it is organized as a function accepting
 * webpack configuration and building context in parameters list.
 *
 * @see https://github.com/postcss/postcss-loader#context-ctx
 */
module.exports = ({options}) => {
  return {
    plugins: {
      /**
       * @see https://github.com/csstools/postcss-preset-env
       *
       * Autoprefixer is already included!
       * @see https://github.com/csstools/postcss-preset-env#autoprefixer)
       *
       * It understands .browserslistrc to apply corresponding polyfills!
       * @see https://github.com/csstools/postcss-preset-env#browsers
       */
      'postcss-preset-env': !options.env.production ? false : {},
      /**
       * @see https://cssnano.co/guides/getting-started/
       */
      cssnano: !options.env.production ? false : {},
      /**
       * @see https://tailwindcss.com/docs/installation#using-tailwind-with-postcss
       */
      tailwindcss: {},
    },
  };
};
EOF