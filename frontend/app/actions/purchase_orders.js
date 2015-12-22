import Qs from 'qs';
import { assign } from 'lodash';
import 'whatwg-fetch';
import { removeEmptyKeys, snakeizeKeys } from '../utilities/inspection';

const defaultParams = { sort_by: 'drop_date_asc' };

function fetchPurchaseOrders(params, page, action) {
  return dispatch => {
    const translatedParams = assign({}, snakeizeKeys(params), { page,
                                                                vendor_id: params.brand,
                                                                po_number: params.poNumber,
                                                                category_id: params.category,
                                                                product_id: params.pid,
                                                                product_sku: params.sku });
    const query = removeEmptyKeys(assign({}, defaultParams, translatedParams));
    const queryString = Qs.stringify(query, { arrayFormat: 'brackets' });

    dispatch(purchaseOrdersLoading(true));

    fetch(`/api/purchase_order_line_items.json?${queryString}`, { credentials: 'same-origin' })
      .then(response => response.json())
      .then(purchaseOrders => {
        dispatch(purchaseOrdersLoading(false));
        dispatch(action(purchaseOrders));
      });
  };
}

function fetchSummary(params) {
  return dispatch => {
    const translatedParams = assign({}, snakeizeKeys(params), { vendor_id: params.brand,
                                                            po_number: params.poNumber,
                                                            category_id: params.category,
                                                            product_id: params.pid,
                                                            product_sku: params.sku });
    const query = removeEmptyKeys(assign({}, defaultParams, translatedParams));
    const queryString = Qs.stringify(query, { arrayFormat: 'brackets' });

    fetch(`/api/purchase_orders.json?${queryString}`, { credentials: 'same-origin' })
      .then(response => response.json())
      .then(summary => dispatch({ ...summary, type:'SET_SUMMARY' }));
  };
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
  };
}

function makeApiRequest(url, params) {
  return dispatch => {
    fetch(url, { credentials: 'same-origin',
                 method: 'POST',
                 headers: { 'Content-Type': 'application/json' },
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
  return { type: 'CLEAR_PURCHASE_ORDERS' };
}

export function cancelPurchaseOrders(id) {
  return makeApiRequest(`/api/purchase_order_line_items/cancel.json`, { id });
}

export function cancelEntirePurchaseOrder(poNumber) {
  return makeApiRequest(`/api/purchase_orders/${poNumber}/cancel.json`, {});
}

export function uncancelPurchaseOrders(id) {
  return makeApiRequest(`/api/purchase_order_line_items/uncancel.json`, { id });
}

export function updatePurchaseOrders(id, params = {}) {
  return makeApiRequest(`/api/purchase_order_line_items.json`, { id, ...params });
}

export function purchaseOrdersLoading(loading) {
  return { loading, type: 'IS_LOADING_PURCHASE_ORDERS' };
}
