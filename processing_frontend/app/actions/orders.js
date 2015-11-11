import React from 'react';
import 'whatwg-fetch';

export function loadOrders() {
  return dispatch => {
    fetch(`/api/orders.json`, { credentials: 'same-origin' })
      .then(response => response.json())
      .then(orders => dispatch({ orders, type: 'SET_ORDERS' }));
  };
}

export function loadOrder(id) {
  return dispatch => {
    fetch(`/api/orders/${id}.json`, { credentials: 'same-origin' })
      .then(response => response.json())
      .then(order => dispatch({ order, type: 'SET_ORDER' }));
  };
}

export function createOrder() {
  return dispatch => {
    fetch(`/api/orders.json`, { credentials: 'same-origin',
                                method: 'post' })
      .then(response => response.json())
      .then(function (order) {
        dispatch({ order, type: 'CREATE_ORDER' });
        dispatch({ type: 'REDIRECT_TO_ORDER' });
      });
  };
}
