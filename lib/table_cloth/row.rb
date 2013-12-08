class TableCloth::Row
  attr_reader :sheet, :bold, :background, :color, :size
  attr_accessor :cells
  def initialize(sheet, options = {})
    @sheet = sheet
    @cells = []
    @sheet.rows.push(self)
    @bold       = options[:bold]       || nil
    @background = options[:background] || nil
    @color      = options[:color]      || nil
    @size       = options[:size]       || nil
  end

  def num_columns
    total_width = 0
    cells.each do |cell|
      width = 1
      if cell.span and 
        cell.span != 'all' and 
        cell.span > 1
        width = cell.span
      end
      total_width += width
    end
    total_width
  end

  def bold?
    bold
  end

  def new_cell(contents, options = {})
    TableCloth::Cell.new(self, contents, options)
  end

  def add_cells(list)
    list.map{|contents| self.new_cell(contents)}
  end
  
  def to_a
    cells.map(&:contents)
  end

  def to_html
    <<-HTML
      <tr>
        #{cells.map(&:to_html).join("\n")}
      </tr>
    HTML
  end

  def filled?
    cells.each do |cell|
      return true if cell.span == 'all'
    end
    false
  end

  def fill
    if num_columns < sheet.num_columns and
      !filled?
      filler_columns = sheet.num_columns - num_columns
      filler_cell = self.new_cell('', span: filler_columns).to_html
    end
  end

  def to_xls
    <<-XML
      <Row>
        #{cells.map(&:to_xls).join}
      </Row>
    XML
  end
end