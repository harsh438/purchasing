const initialState =  { page: 1, purchaseOrders: [] };

function transformPurchaseOrder(purchaseOrder) {
  console.log(purchaseOrder)

  return {
    poNumber: purchaseOrder.summary_id,

    productId: purchaseOrder.product_id,
    productName: purchaseOrder.product_name,
    productSKU: purchaseOrder.product_sku,
    productCost: purchaseOrder.cost,
    productSize: purchaseOrder.product_size,

    orderId: purchaseOrder.id,
    orderDate: purchaseOrder.order_date,
    orderedUnits: purchaseOrder.quantity,
    orderedCost: purchaseOrder.ordered_cost,
    orderedValue: purchaseOrder.ordered_value,

    deliveryDate: purchaseOrder.delivery_date,
    deliveredUnits: purchaseOrder.delivered_quantity,
    deliveredCost: purchaseOrder.delivered_cost,
    deliveredValue: purchaseOrder.delivered_value,

    cancelledUnits: purchaseOrder.cancelled_quantity,
    cancelledCost: purchaseOrder.cancelled_cost,
    cancelledValue: purchaseOrder.cancelled_value,

    balanceUnits: purchaseOrder.balance_quantity,
    balanceCost: purchaseOrder.balance_cost,
    balanceValue: purchaseOrder.balance_value,

    operator: purchaseOrder.operator,
    weeksOnSale: purchaseOrder.weeks_on_sale,
    closingDate: purchaseOrder.closing_date,
    brandSize: purchaseOrder.brand_size,
    gender: purchaseOrder.gender,
    status: purchaseOrder.status,
    comments: purchaseOrder.comments,
  }
}

function appendPurchaseOrders(state, action) {
  const newPurchaseOrders = action.purchaseOrders.map(transformPurchaseOrder);
  const purchaseOrders = [...state.purchaseOrders, ...newPurchaseOrders];
  return Object.assign({}, state, { purchaseOrders, page: action.page });
}

export default function reducePurchaseOrders(state = initialState, action) {
  switch (action.type) {
    case 'APPEND_PURCHASE_ORDERS':
      return appendPurchaseOrders(state, action);
    default:
      return state;
  }
}
