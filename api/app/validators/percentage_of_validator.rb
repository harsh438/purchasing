class PercentageOfValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank? or value.length < 1

    if !is_percentage?(value[:percentage])
      record.errors[attribute] << 'Must be a percentage'
    elsif !is_valid_of?(value[:of])
      record.errors[attribute] << 'Must be a valid option'
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

  def is_valid_of?(of)
    options[:of].include?(of)
  end
end
