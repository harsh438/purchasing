class Order::Exporter
  def export(orders)
    orders.each do |order|
      order.exports.create!
    end
  end
end
