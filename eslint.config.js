/**
 * ESLint flat config (ESLint 9+).
 * Kept small on purpose - the point of the lint job in CI is to show a *fast,
 * cheap* quality gate that runs before the expensive test matrix.
 */
export default [
  {
    ignores: ['dist/**', 'coverage/**', 'node_modules/**'],
  },
  {
    files: ['**/*.js'],
    languageOptions: {
      ecmaVersion: 2023,
      sourceType: 'module',
    },
    rules: {
      'no-unused-vars': 'error',
      'no-undef': 'off',
      eqeqeq: ['error', 'smart'],
      'prefer-const': 'error',
      'no-var': 'error',
    },
  },
];
