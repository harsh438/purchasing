class Order::Exporter
  def export(order)
    order.exports.create!
  end
end
