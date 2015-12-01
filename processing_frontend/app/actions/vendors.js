import React from 'react';
import Qs from 'qs';
import { assign, clone, omit } from 'lodash';
import { snakeizeKeys } from '../utilities/inspection';

export function createVendor(vendor = {}) {
  return dispatch => {
    fetch('/api/vendors.json', { credentials: 'same-origin',
                                 method: 'post',
                                 headers: { 'Content-Type': 'application/json' },
                                 body: JSON.stringify({ vendor: snakeizeKeys(vendor) }) })
      .then(response => response.json())
      .then(vendor => dispatch({ vendor, type: 'CREATE_VENDOR' }));
  };
}

export function loadVendors(query) {
  const queryString = Qs.stringify(assign({}, query, { filters: snakeizeKeys(query.filters) }));

  return dispatch => {
    fetch(`/api/vendors.json?${queryString}`, { credentials: 'same-origin' })
      .then(response => response.json())
      .then(results => dispatch({ results, type: 'SET_VENDORS' }));
  };
}

export function loadVendor(id) {
  return dispatch => {
    fetch(`/api/vendors/${id}.json`, { credentials: 'same-origin' })
      .then(response => response.json())
      .then(vendor => dispatch({ vendor, type: 'SET_VENDOR' }));
  };
}

export function editVendor(vendor) {
  return dispatch => {
    fetch(`/api/vendors/${vendor.id}.json`, { credentials: 'same-origin',
                                              method: 'PATCH',
                                              headers: { 'Content-Type': 'application/json' },
                                              body: JSON.stringify({
                                                      vendor: snakeizeKeys(vendor)
                                                    }) })

    .then(response => response.json())
    .then(results => dispatch({ vendor: results, type: 'SET_VENDOR' }));
  };
}

