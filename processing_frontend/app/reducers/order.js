import { assign, map } from 'lodash';
import { camelizeKeys } from '../utilities/inspection';

const initialState =  { order: [] };

function transformOrder(order) {
  let o = camelizeKeys(order);
  o.lineItems = map(o.lineItems, (line) => camelizeKeys(line));
  return o;
}

function setOrder(state, order) {
  return assign({}, state, { order });
}

export default function reduceOrder(state = initialState, action) {
  switch (action.type) {
    case 'SET_ORDER':
      return setOrder(state, transformOrder(action.order));
    default:
      return state;
  }
}
