import React from 'react';
import { snakeizeKeys } from '../utilities/inspection';


export function createSupplier(params = {}) {
  return dispatch => {
    fetch('/api/suppliers.json', { credentials: 'same-origin',
                                method: 'post',
                                headers: { 'Content-Type': 'application/json' },
                                body: JSON.stringify({ supplier: params }) })
      .then(response => response.json())
      .then(results => dispatch({ results, type: 'CREATE_SUPPLIER' }));
  };
}

export function loadSupplier(id) {
  return dispatch => {
    fetch(`/api/suppliers/${id}.json`, { credentials: 'same-origin' })
      .then(response => response.json())
      .then(results => dispatch({ results, type: 'SET_SUPPLIER' }));
  };
}

export function loadSuppliers(page = 1) {
  return dispatch => {
    fetch(`/api/suppliers.json?page=${page}`, { credentials: 'same-origin' })
      .then(response => response.json())
      .then(results => dispatch({ results, type: 'LOAD_SUPPLIERS' }));
  };
}

export function editSupplier(supplier) {
    let id = supplier.id || supplier.supplier_id;
    console.log(id, supplier);
    if (!id) { return }
    return dispatch => {
      fetch(`/api/suppliers/${id}.json`, { credentials: 'same-origin',
                                                method: 'PATCH',
                                                headers: { 'Content-Type': 'application/json' },
                                                body: JSON.stringify({ supplier: snakeizeKeys(supplier) }) })
      .then(response => response.json())
      .then(results => dispatch({ results, type: 'SET_ORDER' }));
    }
}
