# frozen_string_literal: true

require 'rails_helper'

describe FeedbackFormHelper do
  describe 'show_feedback_form?' do
    let(:form_controller) { FeedbackFormsController.new }
    before do
      form_controller.extend(FeedbackFormHelper)
      allow(form_controller).to receive(:controller).and_return(form_controller)
    end
    it 'should return false when being viewed under the FeedbackFormsController' do
      expect(form_controller.show_feedback_form?).to be_falsey
    end
    it 'should return true when not under the FeedbackFormsController' do
      expect(helper.show_feedback_form?).to be_truthy
    end
  end
end
