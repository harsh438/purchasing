class PercentageDaysOrBlankValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank? or value.length < 1

    if value[:percentage].present? and !is_percentage?(value[:percentage])
      record.errors[attribute] << 'Must be a percentage'
    elsif value[:days].present? and !is_int?(value[:days])
      record.errors[attribute] << 'Must be a valid number of days'
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

  def is_int?(val)
    Integer(val) rescue false
  end
end
