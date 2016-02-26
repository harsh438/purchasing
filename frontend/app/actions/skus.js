import React from 'react';
import Qs from 'qs';
import NotificationSystem from 'react-notification-system';
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

function throw404Error(response) {
  if (response.status === 404) {
    throw "404";
  } else {
    return response;
  }
}

export function createSkuByPid(attrs) {
  return dispatch => {
    fetch(`/api/skus/create_by_pid.json`, { credentials: 'same-origin',
                                    method: 'POST',
                                    headers: { 'Content-Type': 'application/json' },
                                    body: JSON.stringify({ sku: snakeizeKeys(attrs) }) })
    .then(throw404Error)
    .then(response => response.json())
    .then(sku => dispatch({ sku, type: 'LOAD_SKU' }))
    .catch(() => {
      dispatch({ text: `Unable to find PID with ID ${attrs.productId}`, type: 'ERROR_NOTIFICATION' });
    });
  };
}
