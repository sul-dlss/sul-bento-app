# frozen_string_literal: true

class AcademicJournalResultFormatComponent < ResultFormatComponent
  delegate :journal, :page_count, :page_start, :pub_date, to: :result

  def date
    date = Date.parse(result.pub_date)
    date.strftime('%B %Y')
  rescue Date::Error
    date_string
  end

  def details
    [date, volume, issue, pages].compact.join(', ')
  end

  def issue
    "iss. #{result.issue}" if result.issue.present?
  end

  def page_end
    return nil unless page_start.present? && page_count.present?

    start = page_start.to_i
    count = page_count.to_i
    start + count - 1 if start.positive? && count.positive?
  end

  def pages
    "p#{page_start}-#{page_end}" if page_end.present?
  end

  def volume
    "v. #{result.volume}" if result.volume.present?
  end
end
