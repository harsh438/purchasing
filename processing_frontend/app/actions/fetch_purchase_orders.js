function appendPurchaseOrders({ page, purchaseOrders }) {
  return {
    type: 'APPEND_PURCHASE_ORDERS',
    page: page,
    purchaseOrders: purchaseOrders
  };
}

export default function fetchPurchaseOrders(page = 1) {
  return dispatch => {
    fetch(`/api/purchase_orders.json?page=${page}`)
      .then(response => response.json())
      .then(purchaseOrders => dispatch(appendPurchaseOrders({ page, purchaseOrders })));
  }
}
