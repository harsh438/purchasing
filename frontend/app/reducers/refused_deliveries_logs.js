import { assign, map } from 'lodash';
import { camelizeKeys } from '../utilities/inspection';

const initialState =  { refusedDeliveriesLogs: { } };

export default function reduceRefusedDeliveriesLogs(state = initialState, action) {
  switch (action.type) {
  case 'SET_REFUSED_DELIVERIES_LOGS':
    const refusedDeliveriesLogs = map(action.refusedDeliveriesLogs, camelizeKeys);
    return assign({}, state, { refusedDeliveriesLogs });
  default:
    return state;
  }
}
