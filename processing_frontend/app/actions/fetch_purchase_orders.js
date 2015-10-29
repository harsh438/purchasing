function appendPurchaseOrders({ page, purchaseOrders }) {
  return {
    type: 'APPEND_PURCHASE_ORDERS',
    page: page,
    purchaseOrders: purchaseOrders
  };
}

export default function fetchPurchaseOrders(page = 1) {
  return dispatch => {
    fetch(`/api/purchase_orders.json?sort_field=id&sort_dir=desc&page=${page}`)
      .then(response => response.json())
      .then(purchaseOrders => dispatch(appendPurchaseOrders({ page, purchaseOrders })));
  }
}
