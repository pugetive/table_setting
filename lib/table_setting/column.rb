class TableSetting::Column
  attr_reader :title, :style_options, :method_token

  def initialize(title, method_token, options = {})
    @title  = title
    @method_token = method_token
    @style_options = options
  end

end
