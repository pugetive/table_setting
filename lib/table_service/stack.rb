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
    signatures = {}
    cells.each do |cell|
      next if signatures[cell.style_name]
      signatures[cell.style_name] = cell.style_xls
    end

    xml = ''
    signatures.each do |signature_class, signature_xls_style|
      xml += <<-XML
        <Style ss:ID="#{signature_class}">
          #{signature_xls_style}
        </Style>
      XML
    end
    xml
  end
end