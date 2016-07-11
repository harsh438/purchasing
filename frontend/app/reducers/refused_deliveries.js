import { assign, map } from 'lodash';
import { camelizeKeys } from '../utilities/inspection';

const initialState =  { refusedDeliveries: [], refusedDelivery: {} };

export default function reduceRefusedDeliveries(state = initialState, action) {
  switch (action.type) {
  case 'SET_REFUSED_DELIVERIES':
    const refusedDeliveries = map(action.refusedDeliveries, camelizeKeys);
    return assign({}, state, { refusedDeliveries });
  case 'SET_REFUSED_DELIVERY':
    const refusedDelivery = map(action.refusedDelivery, camelizeKeys);
    return assign({}, state, { refusedDelivery });
  default:
    return state;
  }
}
