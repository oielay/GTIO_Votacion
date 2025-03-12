module.exports = {
    preset: 'ts-jest',
    testEnvironment: 'jest-environment-jsdom',
    setupFiles: ['jest-canvas-mock'], // Para mockear `fetch` 'jest-fetch-mock'
    transform: {
        '^.+\\.ts$': ['ts-jest', {
            isolatedModules: true
        }],
    },
    moduleFileExtensions: ['ts', 'js'],
    testMatch: [
      "**/tests/**/*.[jt]s?(x)",
      "**/?(*.)+(spec|test).[tj]s?(x)"
    ]
};