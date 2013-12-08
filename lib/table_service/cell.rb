class TableService::Cell
  attr_reader :row, :contents, :span, :style, :left_index
    
  def initialize(row, contents, options = {})
    @row = row
    @row.cells.push(self)

    @contents = contents
    @span     = options[:span] || 1

    @style = TableService::Style.new(self, options)

    @left_index = column_index
  end

  def set_style(options)
    style.update(options)
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

  def in_column?(number)
    left_index == (number - 1)
  end

  def preceding_cells
    list = []
    my_index = row.cells.index(self)
    row.cells.each do |cell|
      if row.cells.index(cell) < my_index
        list << cell
      else
        break
      end
    end
    list
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

  # def left_index
  #   preceeding_cells.map{|c| c.span}.sum
  # end

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

    def column_index
      lefties = preceding_cells
      if lefties.empty?
        return 0
      end
      lefties.map{|c| c.span}.sum
    end


end