class PercentageDateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank? or value.length < 1

    if !is_percentage?(value[:percentage])
      record.errors[attribute] << 'Must be a percentage'
    elsif value[:date].blank? or !is_valid_date?(value[:date])
      record.errors[attribute] << 'Must be a valid date'
    end
  end

  private

  def is_percentage?(percent)
    return false unless is_float?(percent)

    percent.to_f > 0 || percent.to_f <= 100
  end

  def is_float?(value)
    Float(value) rescue false
  end

  def is_valid_date?(date)
    begin
      Date.parse(date)
      true
    rescue ArgumentError
      false
    end
  end
end
