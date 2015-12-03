import Qs from 'qs';
import { assign } from 'lodash';
import { snakeizeKeys } from '../utilities/inspection';

export function loadSupplierTerms(id) {
  return dispatch => {
    fetch(`/api/supplier_terms/${id}.json`, { credentials: 'same-origin' })
      .then(response => response.json())
      .then(results => dispatch({ results, type: 'SET_SUPPLIER_TERMS' }));
  };
}

export function loadTerms(query = {}) {
  const queryString = Qs.stringify(assign({}, query, { filters: snakeizeKeys(query.filters) }));

  return dispatch => {
    fetch(`/api/supplier_terms.json?${queryString}`, { credentials: 'same-origin' })
      .then(response => response.json())
      .then(results => dispatch({ results, type: 'LOAD_TERMS' }));
  };
}
