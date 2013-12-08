class TableService::Cell
  attr_reader :row, :contents, :span, :style
    
  def initialize(row, contents, options = {})
    @row = row
    @row.cells.push(self)

    @contents = contents
    @bold       = options[:bold]       || nil
    @background = options[:background] || nil
    @color      = options[:color]      || nil
    @size       = options[:size]       || nil
    @span       = options[:span]       || nil

    @style = TableService::Style.new(self)
  end

  def sheet
    row.sheet
  end

  def bold?
    @bold || row.bold
  end

  def background
    @background || row.background
  end

  def color
    @color || row.color
  end

  def size
    @size || row.size
  end

  def to_html
    <<-HTML
      <td #{html_classes} #{span_attribute}>#{contents.blank? ? '&nbsp;' : contents}</td>
    HTML
  end

  def style_name
    style.name
  end

  def style_css
    style.to_css
  end

  def style_xls
    style.to_xls_xml
  end

  def to_xls
    colspan = 1
    if span == 'all'
      colspan = sheet.num_columns
    elsif span
      colspan = span
    end

    if colspan > 1
      column_attribute = %Q{ss:MergeAcross="#{colspan - 1}"}
    end

    %Q{<Cell #{column_attribute} ss:StyleID="#{style.name}"><Data ss:Type="String">#{contents}</Data></Cell>\n}
  end


  private

    def html_classes
      list = []
      if bold?
        list << 'bold'
      end
      list.push(style.name)
      unless list.empty?
        return %Q{class="#{list.join(' ')}"}
      end
      ''
    end

    def span_attribute
      span = 0
      if @span == 'all'
        span = sheet.num_columns
      elsif @span
        span = @span
      end
      if span > 0
        return %Q{colspan="#{span}"}
      end
      ''
    end

end