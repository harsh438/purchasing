import React from 'react';
import 'whatwg-fetch';

export function loadOrders() {
  fetchOrders(1, action('SET_ORDERS'));
}

function fetchOrders(page, action) {
  return dispatch => {
    fetch(`/api/orders.json`, { credentials: 'same-origin' })
      .then(response => response.json())
      .then(orders => { dispatch(action(orders)); });
  }
}

function action(type) {
  return function (orders) {
    return { orders, type };
  }
}
