import Qs from 'qs';
import { snakeizeKeys } from '../utilities/inspection';

function snakeizeAllKeys(object) {
  object = snakeizeKeys(object);
  for (let key in object) {
    if (object[key] instanceof Array) {
      object[key].forEach((item, i) => object[key][i] = snakeizeAllKeys(item));
    }
  }
  return object;
}

export function loadRefusedDeliveries({ dateFrom, dateTo }) {
  return dispatch => {
    const queryString = Qs.stringify({ date_from: dateFrom, date_to: dateTo });

    fetch(`/api/refused_deliveries_logs.json?${queryString}`, { credentials: 'same-origin' })
      .then(response => response.json())
      .then(refusedDeliveries => dispatch({ refusedDeliveries, type: 'SET_REFUSED_DELIVERIES' }));
  };
}


export function createRefusedDelivery(refusedDelivery) {
  return dispatch => {
    fetch('/api/refused_deliveries_logs.json', { credentials: 'same-origin',
                                   method: 'post',
                                   headers: { 'Content-Type': 'application/json' },
                                   body: JSON.stringify({ refused_deliveries_log: snakeizeAllKeys(refusedDelivery) }) })
      .then(response => response.json())
      .then(refusedDelivery => dispatch({ refusedDelivery, type: 'SET_REFUSED_DELIVERY' }));
  };
}
