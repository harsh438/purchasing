import Qs from 'qs';
import { assign } from 'lodash';
import { snakeizeKeys } from '../utilities/inspection';

export function loadSupplierTerms(params = {}) {
  const query = assign({}, params, { filters: snakeizeKeys(params.filters) });
  const queryString = Qs.stringify(query, { arrayFormat: 'brackets' });

  return dispatch => {
    fetch(`/api/supplier_terms.json?${queryString}`, { credentials: 'same-origin' })
      .then(response => response.json())
      .then(results => dispatch({ results, type: 'LOAD_SUPPLIER_TERMS' }));
  };
}

export function loadSingleSupplierTerms(id) {
  return dispatch => {
    fetch(`/api/supplier_terms/${id}.json`, { credentials: 'same-origin' })
      .then(response => response.json())
      .then(results => dispatch({ results, type: 'LOAD_SINGLE_SUPPLIER_TERMS' }));
  };
}
