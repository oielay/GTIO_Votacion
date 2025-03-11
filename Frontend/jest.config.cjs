module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'jest-environment-jsdom',  // Cambiado a 'jest-environment-jsdom'
  setupFiles: ['jest-fetch-mock'],  // Para mockear `fetch`
  transform: {
    '^.+\\.ts$': 'ts-jest',
  },
  moduleFileExtensions: ['ts', 'js'],
};