class TableService::Style
  attr_reader :bold, :size, :background, :color
  def initialize(cell)
    @bold = cell.bold? || cell.row.bold?
    @size = cell.size || cell.row.size
    @background = cell.background || cell.row.background
    @color = cell.color || cell.row.color
  end

  def name
    settings = {
      bold:       bold?,
      background: background,
      size:       size,
      color:      color
    }
    "style-#{Digest::MD5.hexdigest(settings.to_s)[0..7]}"
  end

  def bold?
    bold
  end

  def to_css
    signature = ''
    if bold?
      signature += "font-weight: bold;"
    end
    if size
      signature += "font-size: #{size};"
    end
    if background
      signature += "background-color: #{background};"
    end
    if color
      signature += "color: #{color};"
    end
    signature
  end

  def to_xls_xml
    signature = ''
    font_specs = {}
    if bold?
      font_specs["ss:Bold"] = 1
    end
    if size
    end
    if background
      signature += %Q{<Interior ss:Color="#{background}" ss:Pattern="Solid"/>}
    end
    if color
      font_specs["ss:Color"] = color
    end
    unless font_specs.empty?
      spec_string = ''
      font_specs.each do |key, value|
        spec_string += %Q{#{key}="#{value}" }
      end
      signature += "<ss:Font #{spec_string} />"
    end

    signature
  end
end