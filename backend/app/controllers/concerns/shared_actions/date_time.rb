module SharedActions::DateTime
  extend ActiveSupport::Concern

  def format_japanese_time(datetime)
    datetime.strftime('%Y/%m/%d %H:%M')
  end

end
