import Qs from 'qs';

export function loadRefusedDeliveries({ dateFrom, dateTo }) {
  return dispatch => {
    const queryString = Qs.stringify({ date_from: dateFrom, date_to: dateTo });

    fetch(`/api/refused_deliveries_logs.json?${queryString}`, { credentials: 'same-origin' })
      .then(response => response.json())
      .then(refusedDeliveriesLogs => dispatch({ refusedDeliveriesLogs, type: 'SET_REFUSED_DELIVERIES_LOGS' }));
  };
}


export function createRefusedDeliveries(RefusedDeliveries = {}) {
  return dispatch => {
    fetch('/api/refused_deliveries_logs.json', { credentials: 'same-origin',
                                   method: 'post',
                                   headers: { 'Content-Type': 'application/json' },
                                   body: JSON.stringify({ refused_deliveries_logs: snakeizeKeys(refused_deliveries_logs) }) })
      .then(response => response.json())
      .then(refused_deliveries_logs => dispatch({ refused_deliveries_logs, type: 'CREATE_REFUSED_DELIVERIES_LOGS' }));
  };
}
