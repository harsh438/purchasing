import Qs from 'qs';

export function loadPackingLists({ dateFrom, dateTo }) {
  return dispatch => {
    const queryString = Qs.stringify({ date_from: dateFrom, date_to: dateTo });

    fetch(`/api/packing_lists.json?${queryString}`, { credentials: 'same-origin' })
      .then(response => response.json())
      .then(packingLists => dispatch({ packingLists, type: 'SET_PACKING_LISTS' }));
  };
}
