module.exports = {
  purge: ["./src/**/*.bs.js"],
  theme: {
    extend: {
      colors: {
        primary: "#1e2031",
      },
    },
  },
  variants: {},
  plugins: [],
  future: {
    removeDeprecatedGapUtilities: true,
  },
};
