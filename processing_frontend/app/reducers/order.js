import { assign, map, omit, reject, includes } from 'lodash';
import { camelizeKeys } from '../utilities/inspection';

const initialState =  { order: {} };

function transformOrder(order) {
  const transformedOrder = camelizeKeys(order);
  const transformedLineItems = map(transformedOrder.lineItems, camelizeKeys);
  const transformedPurchaseOrders = map(transformedOrder.purchaseOrders, camelizeKeys);
  return assign({}, transformedOrder, { lineItems: transformedLineItems,
                                        purchaseOrders: transformedPurchaseOrders });
}

function setOrder(state, action) {
  if ('errors' in action.results) {
    return assign({}, state, { errors: action.results });
  }

  return assign({}, state, { order: transformOrder(action.results) });
}

function removeLineItems(state, action) {
  let newLines = reject(state.order.lineItems, (o) => {
    return includes(action.ids, o.id.toString());
  });

  return assign({}, state, { order: assign({}, state.order, { lineItems: newLines }) });
}

export default function reduceOrder(state = initialState, action) {
  switch (action.type) {
    case 'SET_ORDER':
      return setOrder(state, action);
    case 'CREATE_ORDER':
      return setOrder(state, action);
    case 'DELETE_LINE_ITEM':
      return removeLineItems(state, action);
    default:
      return state;
  }
}
