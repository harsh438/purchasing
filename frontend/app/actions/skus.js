import React from 'react';
import Qs from 'qs';
import { assign, clone, omit } from 'lodash';
import { snakeizeKeys } from '../utilities/inspection';

export function loadSkus(query) {
  const queryString = Qs.stringify(assign({}, query, { filters: snakeizeKeys(query.filters) }));

  return dispatch => {
    fetch(`/api/skus.json?${queryString}`, { credentials: 'same-origin' })
      .then(response => response.json())
      .then(results => dispatch({ results, type: 'LOAD_SKUS' }));
  };
}

export function loadSku(id) {
  return dispatch => {
    fetch(`/api/skus/${id}.json`, { credentials: 'same-origin' })
      .then(response => response.json())
      .then(sku => dispatch({ sku, type: 'LOAD_SKU' }));
  };
}
