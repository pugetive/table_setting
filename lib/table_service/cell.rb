class TableService::Cell
  
  def initialize(row, contents, options = {})
    @row = row
    @row.cells.push(self)

    @contents = contents
    @bold  = options[:bold]  || false
    @shade = options[:shade] || nil
    @span  = options[:span]  || nil
  end

  def row
    @row
  end

  def sheet
    row.sheet
  end

  def contents
    @contents
  end

  def bold?
    @bold
  end

  def span
    @span
  end

  def to_html
    <<-HTML
      <td #{html_classes} #{span_attribute}>#{contents.blank? ? '&nbsp;' : contents}</td>
    HTML
  end

  def html_classes
    list = []
    if bold?
      list << 'bold'
    end
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
  
  def to_xls
    if shade
      %Q{<Cell ss:StyleID="c-#{shade.gsub('#', '')}"><Data ss:Type="String">#{contents}</Data></Cell>\n}
    elsif bold?
      %Q{<Cell ss:StyleID="bold"><Data ss:Type="String">#{contents}</Data></Cell>\n}
    else
      %Q{<Cell><Data ss:Type="String">#{contents}</Data></Cell>\n}
    end
  end
  
  def shade
    @shade
  end
end