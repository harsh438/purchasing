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

export function saveSku(id, attrs) {
  return dispatch => {
    fetch(`/api/skus/${id}.json`, { credentials: 'same-origin',
                                    method: 'PATCH',
                                    headers: { 'Content-Type': 'application/json' },
                                    body: JSON.stringify({ sku: snakeizeKeys(attrs) }) })
    .then(response => response.json())
    .then(sku => dispatch({ sku, type: 'LOAD_SKU' }));
  };
}

export function addBarcodeToSku(id, barcode) {
  return saveSku(id, { barcodes_attributes: [{ barcode }] });
}
