// Import jest-dom's custom assertions
import '@testing-library/jest-dom';

// Mock fetch globally
global.fetch = jest.fn();

// Clean up after each test
afterEach(() => {
  jest.clearAllMocks();
});

// Add any custom matchers or global test setup here
expect.extend({
  // Add custom matchers if needed
});

// Mock IntersectionObserver if needed
if (typeof window !== 'undefined') {
  window.IntersectionObserver = class IntersectionObserver {
    constructor() {}
    observe() { return null; }
    unobserve() { return null; }
    disconnect() { return null; }
  };
}

// Suppress console errors/warnings in tests (optional)
// Uncomment if you want to suppress them
/*
const originalError = console.error;
const originalWarn = console.warn;

beforeAll(() => {
  console.error = (...args) => {
    if (/Warning.*not wrapped in act/.test(args[0])) {
      return;
    }
    originalError.call(console, ...args);
  };
  console.warn = (...args) => {
    if (/Warning.*not wrapped in act/.test(args[0])) {
      return;
    }
    originalWarn.call(console, ...args);
  };
});

afterAll(() => {
  console.error = originalError;
  console.warn = originalWarn;
});
*/ 