import humps from 'humps';
const initialState =  { exportable: {},
                        page: 1,
                        purchaseOrders: [],
                        totalPages: 0,
                        totalResults: 0,
                        summary: {} };

function transformPurchaseOrder(purchaseOrder) {
  const camelizedPurchaseOrder = humps.camelizeKeys(purchaseOrder);

  const remappedKeys = { poNumber: purchaseOrder.summary_id,
                         productCost: purchaseOrder.cost,
                         orderId: purchaseOrder.id,
                         orderedUnits: purchaseOrder.quantity };

  return Object.assign({}, camelizedPurchaseOrder, remappedKeys);
}

function transformSummary(summary) {
  return humps.camelizeKeys(summary);
}

function setPurchaseOrders(state, action) {
  const purchaseOrders = action.results.map(transformPurchaseOrder);

  return Object.assign({}, state, { purchaseOrders,
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

  return Object.assign({}, state, { purchaseOrders,
                                    page: action.page,
                                    totalPages: action.totalPages,
                                    totalCount: action.totalCount,
                                    exportable: action.exportable,
                                    summary: transformSummary(action.summary),
                                    moreResultsAvailable: action.moreResultsAvailable });
}

export default function reducePurchaseOrders(state = initialState, action) {
  switch (action.type) {
    case 'SET_PURCHASE_ORDERS':
      return setPurchaseOrders(state, action);
    case 'APPEND_PURCHASE_ORDERS':
      return appendPurchaseOrders(state, action);
    default:
      return state;
  }
}
