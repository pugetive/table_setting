class TableService::Row
  def initialize(sheet, options = {})
    @sheet = sheet
    @cells = []
    @sheet.rows.push(self)
    # @bold = options[:bold] || false
    # @shade = options[:shade] || nil
  end

  def sheet
    @sheet
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
  
  def cells
    @cells
  end

  def new_cell(contents, options = {})
    TableService::Cell.new(self, contents, options)
  end

  def to_a
    cells.map(&:contents)
  end
  
  def to_html
    if num_columns < sheet.num_columns and
      !filled?
      filler_columns = sheet.num_columns - num_columns
      filler_cell = self.new_cell('', span: filler_columns).to_html
    end
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
  
  def to_xls
    <<-XML
      <Row>
        #{cells.map(&:to_xls).join}
      </Row>
    XML
  end
end