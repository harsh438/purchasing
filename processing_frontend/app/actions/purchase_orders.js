import Qs from 'qs';
import { assign, omit, isEmpty, compose, isNumber } from 'lodash';

const defaultParams = { sort_by: 'drop_date_asc' };

function removeEmptyKeys(object) {
  return omit(object, v => !isNumber(v) && isEmpty(v));
}

function fetchPurchaseOrders(params, page, action) {
  return dispatch => {
    const translatedParams = { vendor_id: params.brand,
                               category_id: params.category,
                               summary_id: params.poNumber,
                               product_id: params.pid,
                               product_sku: params.sku,
                               status: params.status,
                               date_from: params.dateFrom,
                               date_until: params.dateUntil,
                               gender: params.gender,
                               order_type: params.orderType,
                               supplier: params.supplier,
                               operator: params.operator,
                               season: params.season,
                               sort_by: params.sortBy,
                               page: page };

    const query = removeEmptyKeys(assign({}, defaultParams, translatedParams));
    const queryString = Qs.stringify(query, { arrayFormat: 'brackets' });

    fetch(`/api/purchase_orders.json?${queryString}`, { credentials: 'same-origin' })
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
             dropNumbers: purchaseOrders.drop_numbers,
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
  };
}

export function cancelPurchaseOrders(ids) {
  return dispatch => {
    let headers = new Headers();
    headers.append('Content-Type', 'application/json');

    fetch(`/api/purchase_orders/cancel`, { credentials: 'same-origin',
                                           method: 'POST',
                                           headers: headers,
                                           body: JSON.stringify({ id: ids }) })
      .then(response => response.json())
      .then(purchaseOrders => dispatch({ purchaseOrders,
                                         type: 'UPDATE_PURCHASE_ORDERS' }));
  };
}
