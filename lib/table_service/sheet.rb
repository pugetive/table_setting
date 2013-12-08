class TableService::Sheet
  attr_reader :stack
  attr_accessor :name, :rows

  @@counter = 0

  def initialize(parent_stack = TableService::Stack.new, options = {})
    @stack = parent_stack
    @stack.sheets.push(self)
    @rows = []

    @@counter += 1
    @name = options[:name] || "Sheet#{@@counter}"
  end

  def cells
    list = []
    rows.each do |row|
      list.concat(row.cells)
    end
    list
  end

  def num_columns
    max = 0
    rows.each do |row|
      if row.num_columns > max
        max = row.num_columns
      end
    end
    max
  end

  def style_column(number, options)
    cells.select{|c| c.in_column?(number)}.map{|c| c.set_style(options)}
  end

  def spacer
    self.new_row.new_cell('', span: 'all')
  end

  def new_row(options = {})
    TableService::Row.new(self, options)
  end
  
  def to_csv
    csv_string = CSV.generate do |csv|
      rows.each do |row|
        csv << row.to_a
      end
    end
    csv_string
  end

  def to_html
    <<-HTML
      <style type="text/css">
        #{css_styles}
      </style>
      <table class="grid-sheet">
        #{rows.map(&:to_html).join("\n")}
      </table>
    HTML
  end

  def css_styles
    signatures = {}
    cells.each do |cell|
      next if signatures[cell.style_name]
      signatures[cell.style_name] = cell.style_css
    end
    # .grid-sheet td {background-color: #fff;}
    # .grid-sheet tr:nth-child(odd) td {background-color: #eee;}
    # .grid-sheet .bold {font-weight: bold;}
    css = <<-CSS
      .grid-sheet {background-color: #ddd; border-collapse: separate; border-spacing: 1px;}
      .grid-sheet td {background-color: #fff;}
    CSS
    signatures.each do |signature_class, signature_css|
      css += "\n.grid-sheet td.#{signature_class} {#{signature_css}}"
    end
    css
  end

  def to_xls(stack_context = false)
    if stack_context
      <<-XML
        <Worksheet ss:Name="#{self.name}">
          <Table>
            #{rows.map(&:to_xls).join}
          </Table>
        </Worksheet>
      XML
    else
      stack.to_xls
    end
  end
end
