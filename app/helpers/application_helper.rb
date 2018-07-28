# frozen_string_literal: true

module ApplicationHelper
  include ActionView::Helpers::DateHelper

  def flash_class(level)
    case level
    when 'notice' then 'info'
    when 'success' then 'success'
    when 'error' then 'danger'
    when 'alert' then 'danger'
    end
  end

  def current_month
    month = Time.now.strftime('%m')
    month = month.to_i + 1
    get_month(month)
  end

  def get_month(index)
    months = %w[January February March April May June July August
                September October November December]
    months[index]
  end

  def current_year
    Time.now.strftime('%Y')
  end
end
