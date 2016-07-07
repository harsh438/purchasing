class Part
  def initialize(kit_manager)
    @kit_manager = kit_manager
  end

  def as_json
    kit_manager.itemCode
  end

  private

  attr_reader :kit_manager
end
