import humps from 'humps';
const initialState =  { page: 1, purchaseOrders: [] };

function transformPurchaseOrder(purchaseOrder) {
  const camelizedPurchaseOrder = humps.camelizeKeys(purchaseOrder);
  const remappedKeys = {
    poNumber: purchaseOrder.summary_id,
    productCost: purchaseOrder.cost,
    orderId: purchaseOrder.id,
    orderedUnits: purchaseOrder.quantity,
    deliveredUnits: purchaseOrder.delivered_quantity,
  };

  return Object.assign({}, camelizedPurchaseOrder, remappedKeys);
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
