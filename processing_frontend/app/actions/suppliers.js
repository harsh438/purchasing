import React from 'react';

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