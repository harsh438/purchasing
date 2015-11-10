import { assign, map } from 'lodash';
import { camelizeKeys } from '../utilities/inspection'

const initialState =  { orders: [] };

export default function reduceOrders(state = initialState, action) {
  switch (action.type) {
    case 'SET_ORDERS':
      return setOrders(state, transform(action.orders));
    default:
      return state;
  }
}

function transform(orders) {
  return map(orders, (o) => camelizeKeys(o))
}

function setOrders(state, orders) {
  return assign({}, state, { orders });
}
