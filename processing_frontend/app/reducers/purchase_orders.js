import humps from 'humps';
import { assign, map, reduce } from 'lodash';

const initialState =  { exportable: {},
                        page: 1,
                        purchaseOrders: {},
                        totalPages: 0,
                        totalCount: 0,
                        summary: {},
                        moreResultsAvailable: false };

function transformPurchaseOrder(action) {
  return function (purchaseOrders, purchaseOrder, id) {
    if (action.dropNumbers) {
      purchaseOrder.drop_number = action.dropNumbers[id];
    }

    const newPurchaseOrder = assign({}, purchaseOrders[id], humps.camelizeKeys(purchaseOrder));
    return assign({}, purchaseOrders, { [id]: newPurchaseOrder });
  };
}

function transformSummary(summary) {
  return humps.camelizeKeys(summary);
}

function setPurchaseOrders(state, action) {
  const purchaseOrders = reduce(action.results, transformPurchaseOrder(action), {});
  return assign({}, state, { purchaseOrders,
                             page: action.page,
                             totalPages: action.totalPages,
                             totalCount: action.totalCount,
                             exportable: action.exportable,
                             summary: transformSummary(action.summary),
                             moreResultsAvailable: action.moreResultsAvailable });
}

function mergePurchaseOrders(state, action) {
  const purchaseOrders = reduce(action.results,
                                transformPurchaseOrder(action),
                                state.purchaseOrders);

  return assign({}, state, { purchaseOrders,
                             page: action.page,
                             totalPages: action.totalPages,
                             totalCount: action.totalCount,
                             exportable: action.exportable,
                             summary: transformSummary(action.summary),
                             moreResultsAvailable: action.moreResultsAvailable });
}

function updatePurchaseOrders(state, action) {
  const purchaseOrders = reduce(action.purchaseOrders,
                                transformPurchaseOrder(action),
                                state.purchaseOrders);


  return assign({}, state, { purchaseOrders });
}

function clearPurchaseOrders(state, action) {
  return assign({}, state, initialState);
}

export default function reducePurchaseOrders(state = initialState, action) {
  switch (action.type) {
    case 'SET_PURCHASE_ORDERS':
      return setPurchaseOrders(state, action);
    case 'MERGE_PURCHASE_ORDERS':
      return mergePurchaseOrders(state, action);
    case 'UPDATE_PURCHASE_ORDERS':
      return updatePurchaseOrders(state, action);
    case 'CLEAR_PURCHASE_ORDERS':
      return clearPurchaseOrders(state, action);
    default:
      return state;
  }
}
