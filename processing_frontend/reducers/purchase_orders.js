const initialState =  { page: null, pages: {} };

export default function reducePurchaseOrders(state = initialState, action) {
  switch (action.type) {
    case 'SET_PURCHASE_ORDERS':
      return Object.assign({}, state, { page: action.page,
                                        pages: { [action.page]: action.purchaseOrders } });
    default:
      return state;
  }
}
