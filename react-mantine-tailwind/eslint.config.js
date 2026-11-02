import typescriptEslintParser from '@typescript-eslint/parser';
import { defineConfig, globalIgnores } from 'eslint/config';
import core from 'eslint-config-kytnacode-core';
import react from 'eslint-config-kytnacode-react';

export default defineConfig([
  globalIgnores(['dist']),
  core,
  react,
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
