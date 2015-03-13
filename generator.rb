require 'color'
require 'digest/md5'

def generate(extension)
  hash = Digest::MD5.hexdigest(extension).sum

  # base_hue = rand
  base_hue = (hash & 0x0000FF) / 256.0

  base_color    = Color::HSL.from_fraction(base_hue, 0.62, 0.63).html
  lighten_color = Color::HSL.from_fraction(base_hue, 0.62, 0.83).html
  darken_color  = Color::HSL.from_fraction(base_hue, 0.62, 0.53).html

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

extensions = %w(zip txt doc png gif mp3)
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
  hash = Digest::MD5.hexdigest(ext).sum

  r = (hash & 0xFF0000) >> 16
  g = (hash & 0x00FF00) >> 8
  b = hash & 0x0000FF

  p [r, g, b]

  generate(ext)
end.join

File.write('output.html', result.gsub(/ICONS/, icons))
