import humps from 'humps';
import { assign, map, reduce } from 'lodash';

const initialState =  { exportable: {},
                        page: 1,
                        purchaseOrders: [],
                        totalPages: 0,
                        totalCount: 0,
                        summary: {},
                        moreResultsAvailable: false };

function transformPurchaseOrder(action) {
  return function (purchaseOrder) {
    if (action.dropNumbers) {
      purchaseOrder.drop_number = action.dropNumbers[purchaseOrder.order_id];
    }

    return humps.camelizeKeys(purchaseOrder);
  };
}

function transformSummary(summary) {
  return humps.camelizeKeys(summary);
}

function setPurchaseOrders(state, action) {
  const purchaseOrders = map(action.results, transformPurchaseOrder(action));

  return assign({}, state, { purchaseOrders,
                             page: action.page,
                             totalPages: action.totalPages,
                             totalCount: action.totalCount,
                             exportable: action.exportable,
                             summary: transformSummary(action.summary),
                             moreResultsAvailable: action.moreResultsAvailable });
}

function appendPurchaseOrders(state, action) {
  const newPurchaseOrders = map(action.results, transformPurchaseOrder(action));
  const purchaseOrders = [...purchaseOrders, ...newPurchaseOrders];

  return assign({}, state, { purchaseOrders,
                             page: action.page,
                             totalPages: action.totalPages,
                             totalCount: action.totalCount,
                             exportable: action.exportable,
                             summary: transformSummary(action.summary),
                             moreResultsAvailable: action.moreResultsAvailable });
}

function updatePurchaseOrder(purchaseOrders, purchaseOrder) {
  const index = findIndex(purchaseOrders, 'orderId', purchaseOrder.orderId);
  const updatedPurchaseOrder = assign({}, purchaseOrders[index], purchaseOrder);
  return purchaseOrders.splice(index, 1, updatedPurchaseOrder);
}

function updatePurchaseOrders(state, action) {
  const updatedPurchaseOrders = map(action.results, transformPurchaseOrder(action));
  const purchaseOrders = reduce(updatedPurchaseOrders, updatePurchaseOrder, state.purchaseOrders);
  return assign({}, state, { purchaseOrders });
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
    case 'UPDATE_PURCHASE_ORDERS':
      return updatePurchaseOrders(state, action);
    case 'CLEAR_PURCHASE_ORDERS':
      return clearPurchaseOrders(state, action);
    default:
      return state;
  }
}
