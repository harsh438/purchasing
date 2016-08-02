require 'set'

class Sku::Deduplicator

  def without_duplicates(*skus)
    skus.each_with_object(Set.new) do |sku, uniq_skus|
      uniq_skus << SetSku.new(
        sku: sku.sku,
        price: sku.price,
        cost_price: sku.cost_price,
        size: sku.size,
        manufacturer_size: sku.manufacturer_size,
        season: sku.season,
      )
    end.map(&:to_h)
  end

  private

  class SetSku

    attr_reader :sku, :price, :cost_price, :size, :manufacturer_size, :season

    def initialize(sku:, price:, cost_price:, size:, manufacturer_size:, season:)
      @sku = sku
      @price = price
      @cost_price = cost_price
      @size = size
      @manufacturer_size = manufacturer_size
      @season = season
    end

    def barcode
      Barcode
        .joins(:sku)
        .where("skus.sku = ? AND skus.season = ?", sku, season.nickname)
        .latest
        .pluck(:barcode)
        .first
    end

    def eql?(obj)
      obj.hash == hash
    end

    def hash
      [SetSku, sku, season].hash
    end

    def to_h
      {
        sku: sku,
        price: price,
        cost_price: cost_price,
        legacy_brand_size: manufacturer_size,
        options: { size: size },
        barcode: barcode,
      }
    end

  end

end
