module Exceptions
  class BarcodeUpdateUniqueError < StandardError
    attr_reader :duplicate

    def initialize(duplicate)
      @duplicate = duplicate
    end

    def message
      "Barcode #{duplicate.barcode} is not unique"
    end
  end

  class BarcodeUpdateError < StandardError; end
  class SkuDuplicationError < StandardError; end
  class SkuUpdateError < StandardError; end
  class InvalidSearchFilters < StandardError; end
end
