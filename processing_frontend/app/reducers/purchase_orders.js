const initialState =  { page: 1, purchaseOrders: [] };

export default function reducePurchaseOrders(state = initialState, action) {
  switch (action.type) {
    case 'APPEND_PURCHASE_ORDERS':
      const purchaseOrders = [...state.purchaseOrders, ...action.purchaseOrders];
      return Object.assign({}, state, { purchaseOrders, page: action.page });
    default:
      return state;
  }
}
