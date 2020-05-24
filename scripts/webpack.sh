cat << EOF > $ROOT/webpack.config.js
const paths = require('./paths.config');

/**
 * @see https://github.com/isaacs/node-glob
 */
const glob = require('glob');

/**
 * @see https://github.com/jantimon/html-webpack-plugin
 */
const HtmlPlugin = require('html-webpack-plugin');

/**
 * @see https://webpack.js.org/plugins/mini-css-extract-plugin/
 */
const MiniCssExtractPlugin = require('mini-css-extract-plugin');

/**
 * @see https://github.com/johnagan/clean-webpack-plugin
 */
const {CleanWebpackPlugin} = require('clean-webpack-plugin');

module.exports = (env = {}) => {
  const useJavascriptLoaders = () => {
    const use = [];

    use.push({
      loader: 'babel-loader',
      options: {
        cacheDirectory: true,
      },
    });

    return use;
  };

  const useCssLoaders = ({modules, purge} = {}) => {
    /**
     * @see https://github.com/webpack-contrib/style-loader
     */
    const styleLoader = 'style-loader';

    const cssExtractLoader = MiniCssExtractPlugin.loader;

    /**
     * @see https://github.com/webpack-contrib/css-loader
     */
    const cssLoader = {
      loader: 'css-loader',
      options: {modules, importLoaders: purge ? 2 : 1, sourceMap: true},
    };

    /**
     * @see https://github.com/postcss/postcss-loader
     */
    const postCssLoader = {
      loader: 'postcss-loader',
      options: {sourceMap: true, config: {ctx: {env}}},
    };

    /**
     *
     * @see https://purgecss.com/
     *
     * When working with such libs as tailwindcss it is necessary to reduce bundle size by removing
     * unused css classes. PurgeCSS is the way and we have several purgecss-based approaches:
     *
     * - webpack plugin @see https://purgecss.com/plugins/webpack.html
     * - postcss plugin @see https://purgecss.com/plugins/postcss.html
     * - using CLI  @see https://purgecss.com/CLI.html
     * - webpack loader @see https://github.com/FullHuman/purgecss-loader
     *
     * We may want to use css modules together with tailwindcss and this is a real problem. Webpack
     * plugin just doesn't work correctly. It strips all classes related to css modules from result
     * css bundle because of interop problems with css-loader. Look at the related topic @see
     * https://purgecss.com/css_modules.html which leads to github issue and implies using postcss
     * plugin. The problem is that provided solution in very unclear. It just provides a piece of
     * configuration without any explanation of what actually makes purgecss work with css modules.
     * The solution is messed up with react specific conditions and dev utils. Purgecss plugin for
     * postcss is automatically used by postcss-loader but the solution also doesn't work with css
     * modules.
     *
     * Two solutions which seem to work are purgecss CLI and webpack loader. The CLI approach scans
     * webpack production build, js and css bundles, looking for classes which are mentioned in js
     * bundles, stripping those classes from css bundles and overwriting css files. This works
     * pretty well but sometimes we may notice false positives: presence of some unused classes
     * which are possibly related to node_modules vendor code. This can easily be fixed by
     * extracting vendor code from app code and getting two js bundles, then applying purgecss to
     * just app bundle. Although the solution works, it still has some downsides. We'll get warnings
     * about css bundle size during production build process. Also having fat bundles may lead to
     * inacurate canculations and excessive splitting by chunks.
     *
     * So the only solution left is using purgecss webpack loader. We just need several webpack
     * rules for handling css assets:
     * - a rule for handling just css modules (scoped by components folder path or *.module.css
     *   regex), which shouldn't be purged
     * - a rule for handling global.css with such stuff as tailwindcss which definitely should be
     *   purged
     * - a rule for handling css imported from node_modules which also should not be purged
     *
     * The only downside with purgecss-loader is that it's quite outdated. But it works just well
     * and its code is very simple (probably I'll make a PR in my spare time).
     */
    const purgeCssLoader = {
      loader: '@fullhuman/purgecss-loader',
      options: {
        content: glob.sync(paths.src('**/*.+(html|ts|tsx)'), {nodir: true}),
      },
    };

    const use = [];

    use.push(env.production ? cssExtractLoader : styleLoader);

    use.push(cssLoader);

    if (purge) use.push(purgeCssLoader);

    use.push(postCssLoader);

    return use;
  };

  return {
    target: 'web',
    mode: env.production ? 'production' : 'development',
    context: paths.src(),
    entry: './index.tsx',
    output: {
      path: paths.dist(),
      filename: env.production ? '[contenthash].[name].js' : 'bundle.js',
      publicPath: '/',
    },
    resolve: {
      extensions: ['.js', '.ts', '.tsx'],
      alias: {
        '~': paths.src(),
      },
    },
    module: {
      rules: [
        {
          oneOf: [
            {
              test: /\.(js|tsx?)$/i,
              use: useJavascriptLoaders(),
            },
            {
              test: /\.css$/i,
              rules: [
                {
                  oneOf: [
                    {
                      include: paths.src('components'),
                      use: useCssLoaders({modules: true, purge: false}),
                    },
                    {
                      include: paths.src('global.css'),
                      use: useCssLoaders({modules: false, purge: env.production}),
                    },
                    {
                      include: /node_modules/,
                      use: useCssLoaders({modules: false, purge: false}),
                    },
                  ],
                },
              ],
            },
            {
              test: /\.html$/i,
              use: ['html-loader'],
            },
            {
              use: ['file-loader'],
            },
          ],
        },
      ],
    },
    plugins: [
      new CleanWebpackPlugin(/* automatically cleans \`output.path\` */),
      new HtmlPlugin({
        template: paths.src('index.html'),
      }),
      new MiniCssExtractPlugin({
        filename: env.production ? '[contenthash].[name].css' : '[name].css',
        chunkFilename: env.production ? '[contenthash].[id].css' : '[id].css',
      }),
    ],
    optimization: {
      splitChunks: {
        cacheGroups: {
          vendor: {
            test: /node_modules/,
            name: 'vendors',
            enforce: true,
            chunks: 'all',
          },
        },
      },
    },
    /**
     * @see https://webpack.js.org/configuration/dev-server/
     */
    devServer: {
      contentBase: paths.dist(),
      compress: true, // \`true\` in official example (but how is it useful in dev?)
      host: '0.0.0.0', // allows access to machine IP from local network devices
      port: 9000,
      // disableHostCheck: true, // uncomment this only for \`ngrock\` demos
    },
  };
};
EOF