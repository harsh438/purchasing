class NumberOrBlankValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if !value.blank? and is_int?(value)
      record.errors[attribute] << 'Must be a number or blank'
    end
  end

  private

  def is_int?(val)
    Integer(val) rescue false
  end
end
