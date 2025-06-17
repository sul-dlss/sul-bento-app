# frozen_string_literal: true

class ResultFormatComponent < ViewComponent::Base
  attr_reader :result

  delegate :format, to: :result

  def initialize(result:)
    @result = result
    super
  end
end
