cat << EOF > $ROOT/.eslintrc.js
module.exports = {
  "env": {
    "browser": true
  },
  "parserOptions": {
    "sourceType": "module",
    "ecmaVersion": 2019,
    "ecmaFeatures": {
      "jsx": true
    }
  },
  "plugins": ["react"],
  "extends": ["eslint:recommended", "eslint-config-prettier", "plugin:react/recommended"],
  "rules": {
    "react/prop-types": 0
  },
  "overrides": [
    {
      "files": ["**/*.ts", "**/*.tsx"],
      "parser": "@typescript-eslint/parser",
      "parserOptions": {
        "project": "./tsconfig.json"
      },
      "plugins": ["@typescript-eslint/eslint-plugin"],
      "extends": [
        "plugin:@typescript-eslint/eslint-recommended",
        "plugin:@typescript-eslint/recommended",
        "eslint-config-prettier/@typescript-eslint"
      ],
      "rules": {
        "@typescript-eslint/explicit-function-return-type": [
          1,
          {
            "allowExpressions": true,
            "allowTypedFunctionExpressions": true,
            "allowHigherOrderFunctions": true
          }
        ]
      }
    },
    {
      "files": ["*.config.js", ".eslintrc.js", "__mocks__/*.js"],
      "env": {
        "node": true
      }
    }
  ],
  "settings": {
    "react": {
      "version": "detect"
    }
  }
}
EOF