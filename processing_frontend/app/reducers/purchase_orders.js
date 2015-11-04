import humps from 'humps';
import { assign } from 'lodash';

const initialState =  { exportable: {},
                        page: 1,
                        purchaseOrders: [],
                        totalPages: 0,
                        totalCount: 0,
                        summary: {},
                        moreResultsAvailable: false };

function transformPurchaseOrder(purchaseOrder) {
  return humps.camelizeKeys(purchaseOrder);
}

function transformSummary(summary) {
  return humps.camelizeKeys(summary);
}

function setPurchaseOrders(state, action) {
  const purchaseOrders = action.results.map(transformPurchaseOrder);

  return assign({}, state, { purchaseOrders,
                             page: action.page,
                             totalPages: action.totalPages,
                             totalCount: action.totalCount,
                             exportable: action.exportable,
                             summary: transformSummary(action.summary),
                             moreResultsAvailable: action.moreResultsAvailable });
}

function appendPurchaseOrders(state, action) {
  const newPurchaseOrders = action.results.map(transformPurchaseOrder);
  const purchaseOrders = [...state.purchaseOrders, ...newPurchaseOrders];

  return assign({}, state, { purchaseOrders,
                             page: action.page,
                             totalPages: action.totalPages,
                             totalCount: action.totalCount,
                             exportable: action.exportable,
                             summary: transformSummary(action.summary),
                             moreResultsAvailable: action.moreResultsAvailable });
}

function clearPurchaseOrders(state, action) {
  return assign({}, state, initialState);
}

export default function reducePurchaseOrders(state = initialState, action) {
  switch (action.type) {
    case 'SET_PURCHASE_ORDERS':
      return setPurchaseOrders(state, action);
    case 'APPEND_PURCHASE_ORDERS':
      return appendPurchaseOrders(state, action);
    case 'CLEAR_PURCHASE_ORDERS':
      return clearPurchaseOrders(state, action);
    default:
      return state;
  }
}
