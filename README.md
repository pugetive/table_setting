# TableService

Styles shared between the HTML and Excel spreadsheets can be applied to individual cells, entire rows, or (once the table is filled out) even columns. Styles are applied using automatically-definied classes rather than applying styles on a per-cell basis inline.

## Installation

Add this line to your application's Gemfile:

    gem 'table_service'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install table_service

## Usage

The following simple example creates a table which has a header featuring large white text on a dark brown background.  Once cell is set to bold text and the footer is set to span both columns.  Exporting with to_html or to_xls should achieve roughly the same formatting.

    sheet = TableService::Sheet.new
    header = sheet.new_row(background: '#3A2212', color: '#ffffff', bold: true, size: '18px')
    header.add_cells(["First Name", "Last Name"])

    sheet.new_row.add_cells(["Fred", "Flintstone"])
    row = sheet.new_row
    row.new_cell("Wilma")
    row.new_cell("Flintstone", bold: true)
    
    footer = sheet.new_row
    footer.new_cell("That is all the people to list.", span: 2)
    
Then export:

    sheet.to_html
    sheet.to_xls
    sheet.to_csv
    
Or maybe you want to turn the whole second column red:

    sheet.style_column(2, background: '#ff6666')

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
