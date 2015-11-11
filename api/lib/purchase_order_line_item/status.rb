class PurchaseOrderLineItem::Status
  def self.sym_from_int(i)
    case i
      when -1
        :cancelled
      when 2
        :new_po
      when 3
        :receiving
      when 4
        :balance
      when 5
        :delivered
      else
        :error
    end
  end

  def self.ints_from_filter_sym(s)
    case s
      when :cancelled
        [-1]
      when :balance
        [2, 4]
      when :received
        [-1, 3, 4, 5]
      else
        [-1, 2, 3, 4, 5]
    end
  end

  def self.ints_from_filter_syms(f)
    f.map { |s| ints_from_filter_sym(s) }.flatten.uniq
  end
end
