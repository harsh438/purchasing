import queryString from 'query-string';

const defaultParams = { sort_field: 'id',
                        sort_dir: 'desc' };

function removeEmptyKeys(object) {
  for (let key in object) {
    if (object.hasOwnProperty(key) && (object[key] == null || object[key] === '')) {
      delete object[key];
    }
  }

  return object;
}

function fetchPurchaseOrders(params, page, action) {
  return dispatch => {
    const translatedParams = { vendor_id: params.brand,
                               category_id: params.category,
                               summary_id: params.poNumber,
                               pid: params.pid,
                               sku: params.sku,
                               status: params.status,
                               page: page };

    const query = removeEmptyKeys(Object.assign({}, defaultParams, translatedParams));

    fetch(`/api/purchase_orders.json?${queryString.stringify(query)}`, { credentials: 'same-origin' })
      .then(response => response.json())
      .then(purchaseOrders => dispatch(action({ page, purchaseOrders })));
  }
}

function setAction({ page, purchaseOrders }) {
  return { type: 'SET_PURCHASE_ORDERS',
           page: page,
           purchaseOrders: purchaseOrders };
}

function appendAction({ page, purchaseOrders }) {
  return { type: 'APPEND_PURCHASE_ORDERS',
           page: page,
           purchaseOrders: purchaseOrders };
}

export function loadPurchaseOrders(params) {
  return fetchPurchaseOrders(params, 1, setAction);
}

export function loadMorePurchaseOrders(params, page) {
  return fetchPurchaseOrders(params, page, appendAction);
}
