import { assign, map, omit } from 'lodash';
import { camelizeKeys } from '../utilities/inspection';

const initialState =  { order: {} };

function transformOrder(order) {
  const transformedOrder = camelizeKeys(order);
  const transformedLineItems = map(transformedOrder.lineItems, camelizeKeys);
  return assign({}, transformedOrder, { lineItems: transformedLineItems });
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
    case 'REDIRECT_TO_ORDER':
      return assign({}, state, { redirectToOrder: true });
    case 'CLEAR_REDIRECT_TO_ORDER':
      return omit(state, 'redirectToOrder');
    default:
      return state;
  }
}
