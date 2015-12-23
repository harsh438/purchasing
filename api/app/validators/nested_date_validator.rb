class NestedDateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    unless is_valid_date?(value[:date])
      record.errors[attribute] << 'Must be a valid date'
    end
  end

  private

  def is_valid_date?(date)
    Date.parse(date)
    true
  rescue ArgumentError
    false
  end
end
