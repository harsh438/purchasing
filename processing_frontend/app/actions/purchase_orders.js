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
                               product_id: params.pid,
                               sku: params.sku,
                               status: params.status,
                               date_from: params.dateFrom,
                               date_until: params.dateUntil,
                               gender: params.gender,
                               order_type: params.orderType,
                               supplier: params.supplier,
                               page: page };

    const query = removeEmptyKeys(Object.assign({}, defaultParams, translatedParams));

    fetch(`/api/purchase_orders.json?${queryString.stringify(query)}`, { credentials: 'same-origin' })
      .then(response => response.json())
      .then(purchaseOrders => dispatch(action(purchaseOrders)));
  }
}

function action(type) {
  return function (purchaseOrders) {
    const { summary, page, results, exportable } = purchaseOrders;

    return { page,
             results,
             type,
             exportable,
             totalPages: purchaseOrders.total_pages,
             totalCount: purchaseOrders.total_count,
             summary: purchaseOrders.summary,
             moreResultsAvailable: purchaseOrders.more_results_available };
  }
}

export function loadPurchaseOrders(params) {
  return fetchPurchaseOrders(params, 1, action('SET_PURCHASE_ORDERS'));
}

export function loadMorePurchaseOrders(params, page) {
  return fetchPurchaseOrders(params, page, action('APPEND_PURCHASE_ORDERS'));
}

export function clearPurchaseOrders() {
  return dispatch => {
    dispatch({ type: 'CLEAR_PURCHASE_ORDERS' });
  }
}
