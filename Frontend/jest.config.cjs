module.exports = {
    preset: 'ts-jest',
    testEnvironment: 'jest-environment-jsdom',
    setupFiles: [], // Para mockear `fetch` 'jest-fetch-mock'
    transform: {
        '^.+\\.ts$': ['ts-jest', {
            isolatedModules: true
        }],
    },
    moduleFileExtensions: ['ts', 'js'],
    testMatch: [
      "**/tests/**/*.[jt]s?(x)",  // This will match files inside the `tests` folder
      "**/?(*.)+(spec|test).[tj]s?(x)"
    ]
};