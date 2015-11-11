import { assign, map } from 'lodash';
import { camelizeKeys } from '../utilities/inspection';

const initialState =  { orders: [] };

function transformOrders(orders) {
  return map(orders, (o) => camelizeKeys(o));
}

function setOrders(state, orders) {
  return assign({}, state, { orders });
}

export default function reduceOrders(state = initialState, action) {
  switch (action.type) {
    case 'SET_ORDERS':
      return setOrders(state, transformOrders(action.orders));
    default:
      return state;
  }
}
