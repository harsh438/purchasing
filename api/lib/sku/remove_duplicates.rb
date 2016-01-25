class Sku::RemoveDuplicates
  def remove
    puts 'Looking for duplicate SKUs... '
    puts "We have matched #{duplicates.count} potential duplicates, more info to come..."
    puts "We found #{identical_groups.count} groups with a total of #{identical_groups.sum(&:count)} SKUs"
    puts "We found #{non_identical_groups.count} unique SKUs that we will leave alone"

    skus_with_and_without_barcodes.tap do |skus_with_and_without_barcodes|
      with_count = skus_with_barcodes(skus_with_and_without_barcodes).count
      without_count = skus_with_and_without_barcodes.count - with_count

      puts "We found #{without_count} identical groups without any barcodes so we will leave these records alone"
      puts "We found #{with_count} identical groups with any barcodes"
    end

    nil
  end

  private

  def skus_with_barcodes(skus_with_and_without_barcodes)
    skus_with_and_without_barcodes.select { |(with, without)| with.any? }
  end

  def skus_with_and_without_barcodes
    identical_groups.reduce([]) do |with_and_without_barcodes, skus|
      with = skus.select { |sku| sku.barcodes.any? }
      without = skus - with
      with_and_without_barcodes << [with, without]
    end
  end

  def identical_groups
    grouped_by_comparable_attributes.select { |grouped_skus| grouped_skus.count > 1 }
  end

  def non_identical_groups
    grouped_by_comparable_attributes.reject { |grouped_skus| grouped_skus.count > 1 }
  end

  def grouped_by_comparable_attributes
    grouped_duplicates.reduce([]) do |identical_groups, skus|
      identical_groups.concat(skus.group_by(&method(:by_comparable_attributes)).values)
    end
  end

  def by_comparable_attributes(sku)
    sku.attributes.symbolize_keys.except(:id, :sku, :created_at, :updated_at)
  end

  def grouped_duplicates
    duplicates.group_by(&method(:by_primary_attrs)).values
  end

  def by_primary_attrs(sku)
    sku_primary_attrs(sku)
  end

  def duplicates
    @cache ||= begin
      base_where = { season: [], manufacturer_sku: [], manufacturer_size: [] }

      where = duplicate_counts.reduce(base_where) do |where, (season, man_sku, man_size, count)|
        where[:season] << season
        where[:manufacturer_sku] << man_sku
        where[:manufacturer_size] << man_size
        where
      end

      uniq_where = where.reduce({}) do |where, (k, v)|
        where.merge(k => v.uniq)
      end

      Sku.includes(:barcodes).where(uniq_where)
    end
  end

  def duplicate_counts
    Sku.group(:season, :manufacturer_sku, :manufacturer_size)
       .having('COUNT(*) > 1')
       .order(sku: :asc)
       .count
       .map(&:flatten)
  end

  def sku_primary_attrs(sku)
    sku.attributes.symbolize_keys.values_at(:season, :manufacturer_sku, :manufacturer_size)
  end
end

# SELECT COUNT(*) as duplicates, sku, manufacturer_sku, manufacturer_size, season
# FROM skus
# GROUP BY season, manufacturer_sku, manufacturer_size
# HAVING duplicates > 1
# ORDER BY sku ASC
