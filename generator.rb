require 'color'

def generate(extension)
  base_hue = rand

  base_color    = Color::HSL.from_fraction(base_hue, 0.62, 0.63).html
  lighten_color = Color::HSL.from_fraction(base_hue, 0.62, 0.83).html
  darken_color  = Color::HSL.from_fraction(base_hue, 0.62, 0.53).html

  template = <<-SVG
    <svg xmlns="http://www.w3.org/2000/svg" width="75" height="100" viewBox="0 0 70 100" enable-background="new 0 0 70 100">
      <path fill="#{base_color}" d="M0 0v100h70v-70l-35-30z"/>

      <path fill="#{lighten_color}" d="M35 0v30h35z"/>
      <path fill="#{darken_color}" d="M70 60v-30h-35z"/>

      <path fill="#{darken_color}" d="M-5 95h70v-15h-70z"/>

      <text x="0" y="92" fill="white" font-size="12" font-family="Menlo">#{extension.upcase}</text>
    </svg>
  SVG
end

extensions = %w(zip txt doc png gif mp3)

result = <<-HTML
  <!doctype html>
  <html>
    <body>
      ICONS
    </body>
  </html>
HTML

srand

icons = extensions.map do |ext|
  generate(ext)
end.join

File.write('output.html', result.gsub(/ICONS/, icons))
