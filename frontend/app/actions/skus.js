import React from 'react';
import Qs from 'qs';
import NotificationSystem from 'react-notification-system';
import { assign, clone, omit } from 'lodash';
import { snakeizeKeys } from '../utilities/inspection';

function throwErrors(response) {
  if (response.status < 200 || response.status >= 300) {
    throw "We are experiencing technical difficulties. Support has been notified.";
  } else {
    return response;
  }
}

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
  let status = 200;
  return dispatch => {
    fetch(`/api/skus/${id}.json`, { credentials: 'same-origin',
                                    method: 'PATCH',
                                    headers: { 'Content-Type': 'application/json' },
                                    body: JSON.stringify({ sku: snakeizeKeys(attrs) }) })
    .then((response) => {
      status = response.status;
      return response;
    })
    .then(response => response.json())
    .then(response => {
      if (status < 200 || status >= 300) {
        throw response.message;
      }
      return response;
    })
    .then(sku => dispatch({ sku, type: 'LOAD_SKU' }))
    .then(() => dispatch({ text: 'SKU has been updated successfully.', type: 'SUCCESS_NOTIFICATION' }))
    .catch((message) => {
      if (typeof message !== 'string') {
        message = 'We are experiencing technical difficulties. Support has been notified.';
      }
      dispatch({ text: message, type: 'ERROR_NOTIFICATION' });
    });
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
  let status = 200;
  return dispatch => {
    fetch(`/api/skus/duplicate.json`, { credentials: 'same-origin',
                                    method: 'POST',
                                    headers: { 'Content-Type': 'application/json' },
                                    body: JSON.stringify({ sku: snakeizeKeys(attrs) }) })
    .then((response) => {
      status = response.status;
      return response;
    })
    .then(response => response.json())
    .then(response => {
      if (status < 200 || status >= 300) {
        throw response.message;
      }
      return response;
    })
    .then(sku => dispatch({ sku, type: 'LOAD_SKU' }))
    .catch((message) => {
      if (typeof message !== 'string') {
        message = 'We are experiencing technical difficulties. Support has been notified.';
      }
      dispatch({ text: message, type: 'ERROR_NOTIFICATION' });
    });
  };
}
