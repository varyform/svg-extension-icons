require 'color'
require 'digest/md5'

def generate(extension)
  color = Digest::MD5.hexdigest(extension)[0..5]
  hsl   = Color::RGB.from_html(color).to_hsl

  hue = hsl.hue / 360.0
  sat = 0.52
  lit = hsl.lightness / 100

  base_color    = Color::HSL.from_fraction(hue, sat, lit).html
  lighten_color = Color::HSL.from_fraction(hue, sat, [lit + 0.1, 1].min).html
  darken_color  = Color::HSL.from_fraction(hue, sat, [lit - 0.1, 0].max).html

  template = <<-SVG
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 96 128" class="file-icon">
      <path fill="#{base_color}" d="M12 0h52l32 32v96h-84z"/>

      <path fill="#{lighten_color}" d="M64 0v32h32z"/>
      <path fill="#{darken_color}" d="M64 32h32v32z"/>

      <path fill="#{darken_color}" d="M0 92h84v24h-84z"/>
      <text x="8" y="110.5" fill="white" font-size="18" font-weight="normal" font-family="Menlo">#{extension.upcase}</text>
    </svg>
  SVG
end

extensions = %w(3gp 7z ace ai aif aiff amr asf asx bat bin bmp bup cab cbr cda cdl cdr chm dat divx dll dmg doc dss dvf dwg eml eps exe fla flv gif gz hqx htm html ifo indd iso jar jpeg jpg lnk log m4a m4b m4p m4v mcd mdb mid mov mp2 mp4 mpeg mpg msi mswmm ogg pdf png pps ps psd pst ptb pub qbb qbw qxd ram rar rm rmvb rtf sea ses sit sitx ss swf tgz thm tif tmp torrent ttf txt unknown vcd vob wav wma wmv wps xls xpi zip)

result = <<-HTML
  <!doctype html>
  <head>
    <style type="text/css">
      .large svg { height: 96px; }
      .medium svg { height: 64px; }
      .small svg { height: 32px; }
      .tiny svg { height: 16px; }
    </style>
  </head>
  <html>
    <body>
      <div class="large"><h2>Large<h2>ICONS</div>
      <div class="medium"><h2>Medium<h2>ICONS</div>
      <div class="small"><h2>Small<h2>ICONS</div>
      <div class="tiny"><h2>Tiny<h2>ICONS</div>
    </body>
  </html>
HTML

icons = extensions.map(&method(:generate)).join

File.write('output.html', result.gsub(/ICONS/, icons))
