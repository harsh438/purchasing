class Sku::CreateByPid
  def create(pid)
    product = Product.find(pid.to_i)
  end
end
