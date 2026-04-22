import { defineConfig, globalIgnores } from 'eslint/config';
import core from 'eslint-config-kytnacode-core';
import react from 'eslint-config-kytnacode-react';

export default defineConfig([globalIgnores(['dist']), core, react]);
