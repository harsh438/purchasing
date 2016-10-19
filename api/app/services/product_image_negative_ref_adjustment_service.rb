require 'set'

class ProductImageNegativeRefAdjustmentService
  include Enumerable

  def each
    result = ActiveRecord::Base.connection.exec_query(grouped_image_table.to_sql)
    images = ProductImage.where(negative_ref: result.rows.map { |row| row[0] })
    @total = images.count.to_f
    images.each { |image| yield(image) }
  end

  def adjust(logger)
    pids_to_touch = Set.new
    each_with_index.each_with_object(pids_to_touch) do |(image, i), pids|
      begin
        pids << image.product_id
        correct_image(image)
        logger.info(format('Adjusted #%d (%.0f%%)', image.id, progress(i)))
      rescue
        logger.error(format('ERROR #%d (%.0f%%)', image.id, progress(i)))
      end
    end
    Product.where(id: pids_to_touch.to_a).update_all(updated_at: Time.current)
  end

  private

  def correct_image(image)
    image.update_column(:negative_ref, actual_negative_ref(image.product_id))
  end

  def total
    @total ||= count.to_f
  end

  def progress(current)
    [((current + 1).to_f/total) * 100.0, 100.0].min
  end

  def valid_negative_pids_query(product_id)
    po_tbl = PurchaseOrderLineItem.arel_table
    po_tbl.project(po_tbl[:orderToolItemID])
          .distinct
          .where(
            po_tbl[:status].between(2..5)
              .and(po_tbl[:pID].eq(product_id))
              .and(po_tbl[:orderToolItemID].gt(0))
          )
  end

  def actual_negative_ref(product_id)
    query = valid_negative_pids_query(product_id).to_sql
    result = ActiveRecord::Base.connection.exec_query(query)
    result[0]['orderToolItemID'] * -1
  end

  def grouped_image_table
    image_tbl = ProductImage.arel_table
    image_tbl
      .project(image_tbl[:negative_ref], image_tbl[:product_id].count(true))
      .where(
        image_tbl[:deleted_at].eq(nil).or(
          image_tbl[:deleted_at].eq('0000-00-00 00:00:00'))
        .and(image_tbl[:negative_ref].not_eq(nil))
      )
      .group(image_tbl[:negative_ref])
      .having(image_tbl[:product_id].count(true).gt(1))
  end
end
