# Internal DOM theme renderer for Midum.
#
# Palette owns the color catalog, while style owns the visual finish.

# Maps a palette to the DOM class that loads its color tokens.
def palette_class(palette: Midum/Theme/Palette) -> String:
  match palette:
    case orange{}:
      "bc-palette-orange"
    case olive{}:
      "bc-palette-olive"

# Maps a style to the DOM class that loads its global finish.
def style_class(style: Midum/Theme/Style) -> String:
  match style:
    case flat{}:
      "bc-style-flat"
    case toon{}:
      "bc-style-toon"

# Shared helper for the global root class.
def theme_tokens(palette: Midum/Theme/Palette, style: Midum/Theme/Style) -> String:
  palette_class(palette) ++ " " ++ style_class(style)

# Used by UI.screen() for the outer page wrapper.
def root_class(palette: Midum/Theme/Palette, style: Midum/Theme/Style) -> String:
  "bc-screen bc-theme " ++ theme_tokens(palette, style)

def base_css() -> String:
  "
  @font-face {
    font-family: \"Midum Inter\";
    src: url(\"/assets/fonts/Inter-Variable.ttf\") format(\"truetype\");
    font-style: normal;
    font-weight: 100 900;
    font-display: swap;
  }

  @font-face {
    font-family: \"Midum Poppins\";
    src: url(\"/assets/fonts/Poppins-Bold.ttf\") format(\"truetype\");
    font-style: normal;
    font-weight: 700;
    font-display: swap;
  }

  @font-face {
    font-family: \"Midum Poppins\";
    src: url(\"/assets/fonts/Poppins-ExtraBold.ttf\") format(\"truetype\");
    font-style: normal;
    font-weight: 800;
    font-display: swap;
  }

  html, body {
    margin: 0;
    background: #ffffff;
  }

  :root {
    --bc-font-ui: \"Midum Inter\", Inter, system-ui, sans-serif;
    --bc-font-display: \"Midum Poppins\", Poppins, \"Midum Inter\", Inter, system-ui, sans-serif;
  }

  .bc-font-ui {
    font-family: var(--bc-font-ui);
  }

  .bc-screen {
    min-height: 100vh;
    background: var(--bc-page-bg);
  }

  .bc-theme {
    color: var(--bc-copy);
    font-family: var(--bc-font-ui);
  }
  "

def orange_css() -> String:
  "
  .bc-palette-orange {
    --bc-page-bg: #fffaf6;
    --bc-copy: #41210d;
    --bc-copy-muted: #7a604e;
    --bc-focus-ring: #ef7d2f;

    --bc-primary-bg: #ef7d2f;
    --bc-primary-hover-bg: #e36d1b;
    --bc-primary-active-bg: #d25f15;
    --bc-primary-text: #fffaf6;
    --bc-primary-border: #ef7d2f;
    --bc-primary-copy: #c96218;
    --bc-primary-gradient-from: #f39c5c;
    --bc-primary-gradient-to: #dc671a;

    --bc-secondary-bg: #fff0e6;
    --bc-secondary-hover-bg: #fbe5d5;
    --bc-secondary-active-bg: #f5dac3;
    --bc-secondary-text: #8c471c;
    --bc-secondary-border: #efc8ab;
    --bc-secondary-copy: #a95d2f;
    --bc-secondary-gradient-from: #fff8f2;
    --bc-secondary-gradient-to: #f6dcc7;

    --bc-neutral-bg: #fffaf6;
    --bc-neutral-hover-bg: #faf2ec;
    --bc-neutral-active-bg: #f2e7df;
    --bc-neutral-text: #4d3627;
    --bc-neutral-border: #e4d6ca;
    --bc-neutral-copy: #6d5341;
    --bc-neutral-gradient-from: #ffffff;
    --bc-neutral-gradient-to: #f3ebe4;

    --bc-success-bg: #5f8b48;
    --bc-success-hover-bg: #567f42;
    --bc-success-active-bg: #4b703a;
    --bc-success-text: #f8fff5;
    --bc-success-border: #5f8b48;
    --bc-success-copy: #4c7339;
    --bc-success-gradient-from: #79a55f;
    --bc-success-gradient-to: #4b703a;

    --bc-warning-bg: #d39a2d;
    --bc-warning-hover-bg: #c48c20;
    --bc-warning-active-bg: #b27f17;
    --bc-warning-text: #fff9ef;
    --bc-warning-border: #d39a2d;
    --bc-warning-copy: #9a6909;
    --bc-warning-gradient-from: #e2b34d;
    --bc-warning-gradient-to: #bc8416;

    --bc-danger-bg: #d6554d;
    --bc-danger-hover-bg: #c84a42;
    --bc-danger-active-bg: #b63f37;
    --bc-danger-text: #fff7f6;
    --bc-danger-border: #d6554d;
    --bc-danger-copy: #b8433b;
    --bc-danger-gradient-from: #e17066;
    --bc-danger-gradient-to: #c8453d;

    --bc-disabled-bg: #f3eee8;
    --bc-disabled-text: #a38a7a;
    --bc-disabled-border: #e2d6cd;
  }
  "

def olive_css() -> String:
  "
  .bc-palette-olive {
    --bc-page-bg: #f7faf1;
    --bc-copy: #273012;
    --bc-copy-muted: #5f664c;
    --bc-focus-ring: #6f8540;

    --bc-primary-bg: #6f8540;
    --bc-primary-hover-bg: #61753a;
    --bc-primary-active-bg: #556634;
    --bc-primary-text: #fbfdf6;
    --bc-primary-border: #6f8540;
    --bc-primary-copy: #61753a;
    --bc-primary-gradient-from: #899e57;
    --bc-primary-gradient-to: #5a6f36;

    --bc-secondary-bg: #edf2e3;
    --bc-secondary-hover-bg: #e3ebd3;
    --bc-secondary-active-bg: #d7e2c2;
    --bc-secondary-text: #48582a;
    --bc-secondary-border: #cad7b1;
    --bc-secondary-copy: #667648;
    --bc-secondary-gradient-from: #f7faef;
    --bc-secondary-gradient-to: #dce7c8;

    --bc-neutral-bg: #f8f8f4;
    --bc-neutral-hover-bg: #f0f1ea;
    --bc-neutral-active-bg: #e5e8df;
    --bc-neutral-text: #343a28;
    --bc-neutral-border: #d9ddcf;
    --bc-neutral-copy: #5b6150;
    --bc-neutral-gradient-from: #ffffff;
    --bc-neutral-gradient-to: #ecefe4;

    --bc-success-bg: #4f8a57;
    --bc-success-hover-bg: #477c4f;
    --bc-success-active-bg: #3d6d45;
    --bc-success-text: #f6fff7;
    --bc-success-border: #4f8a57;
    --bc-success-copy: #417046;
    --bc-success-gradient-from: #6da975;
    --bc-success-gradient-to: #417046;

    --bc-warning-bg: #c8a03a;
    --bc-warning-hover-bg: #b7912f;
    --bc-warning-active-bg: #a5811f;
    --bc-warning-text: #fffdf5;
    --bc-warning-border: #c8a03a;
    --bc-warning-copy: #8b6811;
    --bc-warning-gradient-from: #dbbb5b;
    --bc-warning-gradient-to: #b38418;

    --bc-danger-bg: #b9554f;
    --bc-danger-hover-bg: #aa4b45;
    --bc-danger-active-bg: #98403b;
    --bc-danger-text: #fff8f7;
    --bc-danger-border: #b9554f;
    --bc-danger-copy: #97403a;
    --bc-danger-gradient-from: #ce6e68;
    --bc-danger-gradient-to: #a34742;

    --bc-disabled-bg: #edf0e7;
    --bc-disabled-text: #889174;
    --bc-disabled-border: #d7dccd;
  }
  "

def css() -> String:
  base_css() ++ orange_css() ++ olive_css()
