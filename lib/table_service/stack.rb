class TableService::Stack
  attr_accessor :sheets

  def initialize
    @sheets = []
  end

  def cells
    list = []
    sheets.each do |sheet|
      list += sheet.cells
    end
    list
  end
  

  def new_sheet(options = {})
    TableService::Sheet.new(self, options)
  end

  def to_xls
    xml = <<-XML
      <?xml version="1.0"?>
      <Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"
        xmlns:o="urn:schemas-microsoft-com:office:office"
        xmlns:x="urn:schemas-microsoft-com:office:excel"
        xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
        xmlns:html="http://www.w3.org/TR/REC-html40">
        <Styles>
        #{xls_styles}
        </Styles>
        #{sheets.map{|s| s.to_xls(true)}.join}
      </Workbook>
    XML
    xml.strip!
  end


  def xls_styles
    defined_colors = {}
    rv = ""
  
    cells.each do |cell|
      if cell.shade and defined_colors[cell.shade].blank?
        rv += <<-XML
          <Style ss:ID="c-#{cell.shade.gsub('#', '')}">
            <Interior ss:Color="#{cell.shade}" ss:Pattern="Solid"/>
            <ss:Font ss:Bold="1"/>
          </Style>
          <Style ss:ID="bold">
            <ss:Font ss:Bold="1"/>
          </Style>
        XML
        defined_colors[cell.shade] ||= 0
        defined_colors[cell.shade] += 1
      end
    end
    rv
  end


end