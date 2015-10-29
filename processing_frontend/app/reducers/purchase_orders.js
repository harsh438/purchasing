const initialState =  { page: 1, purchaseOrders: [] };

function transformPurchaseOrder(purchaseOrder) {
  return {
    orderId: purchaseOrder.id,
    poNumber: purchaseOrder.summary_id,
    productId: purchaseOrder.product_id,
    productName: purchaseOrder.product_name,
    productSKU: purchaseOrder.product_sku,
    productCost: purchaseOrder.cost,
    productSize: purchaseOrder.product_size,
    operator: purchaseOrder.operator,
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
