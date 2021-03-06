class TableSetting::Sheet
  attr_reader :stack, :debug
  attr_accessor :name, :rows

  @@counter = 0

  def initialize(parent_stack = nil, options = {})
    @stack = parent_stack || TableSetting::Stack.new
    @stack.sheets.push(self)
    @rows = []
    @debug = options[:debug]

    @@counter += 1
    @name = options[:name] || "Sheet#{@@counter}"
  end

  def cells
    rows.map(&:cells).flatten
  end

  def num_columns
    rows.map{|row| row.num_columns}.sort.last
  end

  def style_column(number, options)
    rows.each do |row|
      if options[:skip_row] and options[:skip_row] == rows.index(row) + 1
        next
      end
      row.fill
      row.cells.select{|c| c.in_column?(number)}.map{|c| c.set_style(options)}
    end
  end

  def spacer
    self.new_row.new_cell('', span: 'all')
  end

  def new_row(options = {})
    TableSetting::Row.new(self, options)
  end
  
  def to_csv
    csv_string = CSV.generate do |csv|
      rows.each do |row|
        csv << row.to_a
      end
    end
    csv_string
  end

  def index
    @index ||= sheet.rows.index(self)
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
      next if signature_css.empty?
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
