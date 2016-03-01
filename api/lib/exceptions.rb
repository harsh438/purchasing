module Exceptions
  class BarcodeUpdateUniqueError < StandardError
    attr_reader :duplicate

    def initialize(duplicate)
      @duplicate = duplicate
    end
  end
end
