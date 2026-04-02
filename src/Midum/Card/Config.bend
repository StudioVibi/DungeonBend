# Public inline inspector config for cards.
#
# The call site stays small while concrete presentation values remain explicit
# in the renderer input.

type Config {
  card{
    padding: Midum/Card/Padding,
    radius: Midum/Card/Radius,
    background: Midum/Card/Background,
    border: Midum/Card/Border,
    gradient: Midum/Card/Gradient,
    surface: Midum/Card/Surface,
  }
}
