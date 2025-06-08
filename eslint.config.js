// eslint.config.js
import globals from "globals";
import botWhatsappPlugin from 'eslint-plugin-bot-whatsapp';

export default [
  // 1. Include the recommended configuration from eslint-plugin-bot-whatsapp
  // This should handle plugin registration and recommended rules.
  {
    // Spread the recommended config from the plugin
    ...botWhatsappPlugin.configs.recommended,
    // Explicitly ensure the plugin is registered within this same config block
    // This helps ESLint associate rules like 'bot-whatsapp/rule-name' with the plugin.
    plugins: {
      // Preserve any plugins that recommended config might already define (if any)
      ...(botWhatsappPlugin.configs.recommended.plugins || {}),
      'bot-whatsapp': botWhatsappPlugin
    }
  },

  // 2. Global configuration for your project files (e.g., app.js, etc.)
  {
    files: ["**/*.js"],
    ignores: [
      "node_modules/",
      "eslint.config.js" // This specific config block is not for eslint.config.js itself
    ],
    languageOptions: {
      ecmaVersion: "latest", // From old parserOptions.ecmaVersion and env.es2021
      sourceType: "module", // Changed from "commonjs" to "module"
      globals: {
        ...globals.node,     // For Node.js specific globals (like process, console)
        ...globals.browser,  // From old env.browser (if your bot/app interacts with browser-like environments)
      }
    },
    // Rules can be added or overridden here if needed, for example:
    // rules: {
    //   "semi": ["error", "always"]
    // }
  },

  // 3. Configuration for the ESLint config file itself (eslint.config.js)
  //    This ensures it's linted correctly.
  {
    files: ["eslint.config.js"],
    languageOptions: {
      ecmaVersion: "latest",
      sourceType: "module", // eslint.config.js uses import/export, so "module" is appropriate
      globals: {
        ...globals.node, // Provides 'module', 'require', '__dirname', '__filename', etc.
      }
    }
  }
];
