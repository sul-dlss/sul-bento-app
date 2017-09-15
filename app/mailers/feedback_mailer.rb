# frozen_string_literal: true

##
# Mailer for feedback form
class FeedbackMailer < ActionMailer::Base
  def submit_feedback(params, ip)
    @mailer_parser = FeedbackMailerParser.new(params, ip)

    mail(to: Settings.EMAIL_TO.FEEDBACK,
         subject: 'Feedback from SearchWorks',
         from: 'feedback@searchworks.stanford.edu',
         reply_to: Settings.EMAIL_TO.FEEDBACK)
  end
end
