/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{vue,js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        culinary: {
          bg: '#FAF8F5',
          card: '#FFFFFF',
          primary: '#064E3B',
          primaryLight: '#047857',
          accent: '#10B981',
          accentMuted: '#ECFDF5',
          border: '#E2E8F0',
          textMain: '#0F172A',
          textMuted: '#64748B'
        },
        emerald: {
          950: '#064E3B',
          800: '#065F46',
          700: '#047857',
          600: '#059669',
          500: '#10B981',
          100: '#D1FAE5',
          50: '#ECFDF5'
        },
        kitchen: {
          dark: '#0F172A',
          surface: '#022C22',
          card: '#064E3B'
        }
      },
      borderRadius: {
        'squircle-sm': '12px',
        'squircle-md': '18px',
        'squircle-lg': '24px'
      },
      boxShadow: {
        'soft': '0 4px 20px -2px rgba(26, 28, 25, 0.05)',
        'elevated': '0 10px 30px -4px rgba(26, 28, 25, 0.08)'
      }
    },
  },
  plugins: [],
}
