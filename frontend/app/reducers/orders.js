import { assign, map } from 'lodash';
import { camelizeKeys } from '../utilities/inspection';

const initialState =  { orders: [], orderTypes: [], totalPages: null, activePage: null };

function transformOrders(orders) {
  return map(orders, (o) => camelizeKeys(o));
}

function setOrders(state, results) {
  results = camelizeKeys(results);
  results.orders = transformOrders(results.orders);

  return assign({}, state, { orders: results.orders,
                             orderTypes: orderTypes(),
                             totalPages: results.totalPages,
                             activePage: results.page });
}

function orderTypes() {
  return [{ id: 'preorder', name: 'Pre-order' },
          { id: 'suppliers_risk', name: 'Suppliers Risk' },
          { id: 'reorder', name: 'Reorder' },
          { id: 'over_delivery', name: 'Over Delivery' },
          { id: 'bulk_order', name: 'Bulk Order' }];
}

export default function reduceOrders(state = initialState, action) {
  switch (action.type) {
  case 'SET_ORDERS':
    return setOrders(state, action.results);
  default:
    return state;
  }
}
