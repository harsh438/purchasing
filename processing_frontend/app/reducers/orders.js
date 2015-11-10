import { assign } from 'lodash';

const initialState =  { orders: [] };

export default function reduceOrders(state = initialState, action) {
  switch (action.type) {
    case 'SET_ORDERS':
      return setOrders(state, action);
    default:
      return state;
  }
}

function setOrders(state, action, orders) {
  return assign({}, state, { orders });
}
