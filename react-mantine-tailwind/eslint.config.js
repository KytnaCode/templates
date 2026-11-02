import typescriptEslintParser from '@typescript-eslint/parser';
import vitest from '@vitest/eslint-plugin';
import { defineConfig, globalIgnores } from 'eslint/config';
import core from 'eslint-config-kytnacode-core';
import react from 'eslint-config-kytnacode-react';

export default defineConfig([
  globalIgnores(['dist']),
  core,
  react,
  {
    files: ['**/*.{test,spec}.{ts,tsx}'],
    plugins: { vitest },
    extends: [vitest.configs.recommended],
    languageOptions: {
      globals: vitest.environments.env.globals,
    },
  },
  {
    languageOptions: {
      parser: typescriptEslintParser,
    },
    settings: {
      react: {
        version: '19',
      },
    },
  },
]);
