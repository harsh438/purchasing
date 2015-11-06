import Qs from 'qs';
import { assign, omit, isEmpty, isNumber, mapKeys, snakeCase, rearg } from 'lodash';

const defaultParams = { sort_by: 'drop_date_asc' };

function removeEmptyKeys(object) {
  return omit(object, v => !isNumber(v) && isEmpty(v));
}

function fetchPurchaseOrders(params, page, action) {
  return dispatch => {
    const snakeCasedParams = mapKeys(params, rearg(snakeCase, [1, 0]));
    const translatedParams = assign({}, snakeCasedParams, { page,
                                                            vendor_id: params.brand,
                                                            summary_id: params.poNumber,
                                                            category_id: params.category,
                                                            product_id: params.pid,
                                                            product_sku: params.sku });
    const query = removeEmptyKeys(assign({}, defaultParams, translatedParams));
    const queryString = Qs.stringify(query, { arrayFormat: 'brackets' });

    fetch(`/api/purchase_orders.json?${queryString}`, { credentials: 'same-origin' })
      .then(response => response.json())
      .then(purchaseOrders => dispatch(action(purchaseOrders)));
  }
}

function fetchSummary(params) {
  return dispatch => {
    const snakeCasedParams = mapKeys(params, rearg(snakeCase, [1, 0]));
    const translatedParams = assign({}, snakeCasedParams, { vendor_id: params.brand,
                                                            summary_id: params.poNumber,
                                                            category_id: params.category,
                                                            product_id: params.pid,
                                                            product_sku: params.sku });
    const query = removeEmptyKeys(assign({}, defaultParams, translatedParams));
    const queryString = Qs.stringify(query, { arrayFormat: 'brackets' });

    fetch(`/api/purchase_orders/summary.json?${queryString}`, { credentials: 'same-origin' })
      .then(response => response.json())
      .then(summary => dispatch({ ...summary, type:'SET_SUMMARY' }));
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

function makeApiRequest(url, params) {
  return dispatch => {
    let headers = new Headers();
    headers.append('Content-Type', 'application/json');

    fetch(url, { credentials: 'same-origin',
                 method: 'POST',
                 headers: headers,
                 body: JSON.stringify(params) })
      .then(response => response.json())
      .then(purchaseOrders => {
        dispatch({ purchaseOrders, type: 'UPDATE_PURCHASE_ORDERS' });
      });
  };
}

export function loadSummary(params) {
  return fetchSummary(params);
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

export function cancelPurchaseOrders(id) {
  return makeApiRequest(`/api/purchase_orders/cancel`, { id })
}

export function uncancelPurchaseOrders(id) {
  return makeApiRequest(`/api/purchase_orders/uncancel`, { id })
}

export function updatePurchaseOrders(id, params = {}) {
  return makeApiRequest(`/api/purchase_orders/update`, { id, ...params });
}
