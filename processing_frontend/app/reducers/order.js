import { assign, map, omit } from 'lodash';
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
  return assign({}, state, { order: transformOrder(action.order) });
}

export default function reduceOrder(state = initialState, action) {
  switch (action.type) {
    case 'SET_ORDER':
      return setOrder(state, action);
    case 'CREATE_ORDER':
      return setOrder(state, action);
    default:
      return state;
  }
}
