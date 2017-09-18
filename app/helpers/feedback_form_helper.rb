# frozen_string_literal: true

##
# Helpers for the feedback form
module FeedbackFormHelper
  ##
  # Ported from QuickSearch, as the application layout is dependent on it.
  def body_class
    [controller_name, action_name].join('-')
  end

  def show_feedback_form?
    !controller.instance_of?(FeedbackFormsController)
  end
end
