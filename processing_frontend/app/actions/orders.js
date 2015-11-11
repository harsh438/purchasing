import React from 'react';
import 'whatwg-fetch';

export function loadOrders() {
  return fetchOrders(1, ordersAction('SET_ORDERS'));
}

export function loadOrder(id) {
  return fetchOrder(id, orderAction('SET_ORDER'));
}

function fetchOrders(page, action) {
  return dispatch => {
    fetch(`/api/orders.json`, { credentials: 'same-origin' })
      .then(response => response.json())
      .then(orders => dispatch(action(orders)));
  }
}

function fetchOrder(id, action) {
  return dispatch => {
    fetch(`/api/orders/${id}.json`, { credentials: 'same-origin' })
      .then(response => response.json())
      .then(order => dispatch(action(order)));
  }
}

function ordersAction(type) {
  return function (orders) {
    return { orders, type };
  }
}

function orderAction(type) {
  return function (order) {
    return { order, type };
  }
}
