class PercentageOrBlankValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if !value.blank? and (value.to_f <= 0 or value.to_f > 100)
      record.errors[attribute] << 'Must be a percentage or empty'
    end
  end
end
