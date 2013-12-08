class TableSetting::Column
  def initialize(title, method, options = {})
    @title  = title
    @method = method
  end

  def title
    @title
  end

  def method
    @method
  end
end
