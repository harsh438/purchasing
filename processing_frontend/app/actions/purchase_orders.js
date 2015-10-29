function fetchPurchaseOrders(params, page, action) {
  return dispatch => {
    let query = [];

    if (params.brand) {
      query.push(`vendor_id=${params.brand}`);
    }

    if (params.category) {
      query.push(`category_id=${params.category}`);
    }

    fetch(`/api/purchase_orders.json?sort_field=id&sort_dir=desc&page=${page}&${query.join('&')}`)
      .then(response => response.json())
      .then(purchaseOrders => dispatch(action({ page, purchaseOrders })));
  }
}

function setAction({ page, purchaseOrders }) {
  return {
    type: 'SET_PURCHASE_ORDERS',
    page: page,
    purchaseOrders: purchaseOrders
  };
}

function appendAction({ page, purchaseOrders }) {
  return {
    type: 'APPEND_PURCHASE_ORDERS',
    page: page,
    purchaseOrders: purchaseOrders
  };
}

export function loadPurchaseOrders(params) {
  return fetchPurchaseOrders(params, 1, setAction);
}

export function loadMorePurchaseOrders(params, page) {
  return fetchPurchaseOrders(params, page, appendAction);
}
