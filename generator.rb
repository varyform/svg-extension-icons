require 'color'
require 'digest/md5'

def generate(extension)
  color = Digest::MD5.hexdigest(extension)[0..5]

  hue = Color::RGB.from_html(color).to_hsl.hue / 360.0
  sat = Color::RGB.from_html(color).to_hsl.saturation / 100
  lit = Color::RGB.from_html(color).to_hsl.lightness / 100
  p [color, hue]

  # hue = Color::RGB.from_html(color)

  base_color    = Color::HSL.from_fraction(hue, 0.62, lit).html
  lighten_color = Color::HSL.from_fraction(hue, 0.62, [lit + 0.1, 1].min).html
  darken_color  = Color::HSL.from_fraction(hue, 0.62, [lit - 0.1, 0].max).html

  # base_color    = '#' + color
  # lighten_color = '#' + color
  # darken_color  = '#' + color

  template = <<-SVG
    <svg xmlns="http://www.w3.org/2000/svg" width="75" height="100" viewBox="0 0 70 100" enable-background="new 0 0 70 100">
      <path fill="#{base_color}" d="M0 0v100h70v-70l-35-30z"/>

      <path fill="#{lighten_color}" d="M35 0v30h35z"/>
      <path fill="#{darken_color}" d="M70 60v-30h-35z"/>

      <path fill="#{darken_color}" d="M-5 95h70v-15h-70z"/>

      <text x="2" y="92" fill="white" font-size="12" font-family="Menlo">#{extension.upcase}</text>
    </svg>
  SVG
end

# extensions = %w(zip txt doc png gif mp3)
extensions = %w(3gp 7z ace ai aif aiff amr asf asx bat bin bmp bup cab cbr cda cdl cdr chm dat divx dll dmg doc dss dvf dwg eml eps exe fla flv gif gz hqx htm html ifo indd iso jar jpeg jpg lnk log m4a m4b m4p m4v mcd mdb mid mov mp2 mp4 mpeg mpg msi mswmm ogg pdf png pps ps psd pst ptb pub qbb qbw qxd ram rar rm rmvb rtf sea ses sit sitx ss swf tgz thm tif tmp torrent ttf txt unknown vcd vob wav wma wmv wps xls xpi zip)

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
