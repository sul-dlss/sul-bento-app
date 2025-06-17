# frozen_string_literal: true

class BookResultFormatComponent < ResultFormatComponent
  def pub_year
    "(#{result.pub_year})" if result.pub_year
  end
end
