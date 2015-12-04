import React from 'react';
import Qs from 'qs';
import { assign, clone, omit } from 'lodash';
import { snakeizeKeys } from '../utilities/inspection';

export function createSupplier(supplier = {}) {
  return dispatch => {
    fetch('/api/suppliers.json', { credentials: 'same-origin',
                                   method: 'post',
                                   headers: { 'Content-Type': 'application/json' },
                                   body: JSON.stringify({ supplier: snakeizeKeys(supplier) }) })
      .then(response => response.json())
      .then(supplier => dispatch({ supplier, type: 'CREATE_SUPPLIER' }));
  };
}

export function loadSupplier(id) {
  return dispatch => {
    fetch(`/api/suppliers/${id}.json`, { credentials: 'same-origin' })
      .then(response => response.json())
      .then(supplier => dispatch({ supplier, type: 'SET_SUPPLIER' }));
  };
}

export function loadSupplierNames() {
  return dispatch => {
    fetch(`/api/suppliers.json?name_only=1`, { credentials: 'same-origin' })
      .then(response => response.json())
      .then(results => dispatch({ results, type: 'LOAD_SUPPLIERS' }));
  };
}

export function loadSuppliers(query) {
  const queryString = Qs.stringify(assign({}, query, { filters: snakeizeKeys(query.filters) }));

  return dispatch => {
    fetch(`/api/suppliers.json?${queryString}`, { credentials: 'same-origin' })
      .then(response => response.json())
      .then(results => dispatch({ results, type: 'LOAD_SUPPLIERS' }));
  };
}

export function editSupplier(supplier) {
  let id = supplier.id || supplier.supplier_id;

  if (!id) return;

  return dispatch => {
    fetch(`/api/suppliers/${id}.json`, { credentials: 'same-origin',
                                         method: 'PATCH',
                                         headers: { 'Content-Type': 'application/json' },
                                         body: JSON.stringify({ supplier: snakeizeKeys(supplier) }) })
    .then(response => response.json())
    .then(results=> dispatch({ supplier: results, type: 'SET_SUPPLIER' }));
  };
}

export function saveSupplierContact(supplier, contact) {
  return editSupplier({ id: supplier.id, contacts_attributes: [contact] });
}

export function saveTerms(id, terms) {
  return editSupplier({ id, terms: omit(snakeizeKeys(terms), 'id') });
}
