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
          bg: '#FAF7F2',
          canvas: '#FAF7F2',
          card: '#FFFFFF',
          surface: '#FFFFFF',
          primary: '#165337',
          brand: '#165337',
          'brand-surface': '#EBF3EF',
          primaryLight: '#235440',
          accent: '#10B981',
          accentMuted: '#ECFDF5',
          missing: '#C2410C',
          border: '#E8E2D8',
          textMain: '#18181B',
          ink: '#18181B',
          textMuted: '#71717A',
          muted: '#71717A',
          cook: {
            bg: '#061811',
            card: '#0A261B',
            accent: '#22C55E'
          }
        },
        emerald: {
          950: '#165337',
          900: '#165337',
          800: '#235440',
          700: '#2E6950',
          600: '#059669',
          500: '#10B981',
          100: '#D1FAE5',
          50: '#ECFDF5'
        },
        kitchen: {
          dark: '#061811',
          surface: '#0A261B',
          card: '#0A261B'
        }
      },
      fontFamily: {
        sans: ['Plus Jakarta Sans', 'Inter', '-apple-system', 'BlinkMacSystemFont', 'Segoe UI', 'Roboto', 'sans-serif'],
        mono: ['JetBrains Mono', 'monospace']
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
