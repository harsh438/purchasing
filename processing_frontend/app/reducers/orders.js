import { assign, map } from 'lodash';
import { camelizeKeys } from '../utilities/inspection';

const initialState =  { orders: [] };

function transformOrders(orders) {
  return map(orders, (o) => camelizeKeys(o));
}

function setOrders(state, results) {
  results = camelizeKeys(results)
  results.orders = transformOrders(results.orders)

  return assign({}, state, { orders: results.orders,
                             totalPages: results.totalPages,
                             activePage: results.page });
}

export default function reduceOrders(state = initialState, action) {
  switch (action.type) {
    case 'SET_ORDERS':
      return setOrders(state, action.results);
    default:
      return state;
  }
}
