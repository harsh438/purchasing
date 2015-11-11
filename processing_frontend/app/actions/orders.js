import React from 'react';
import 'whatwg-fetch';
import { map } from 'lodash'
import { snakeizeKeys } from '../utilities/inspection'

export function loadOrders() {
  return dispatch => {
    fetch(`/api/orders.json`, { credentials: 'same-origin' })
      .then(response => response.json())
      .then(orders => dispatch({ orders, type: 'SET_ORDERS' }));
  };
}

export function createOrder() {
  return dispatch => {
    fetch(`/api/orders.json`, { credentials: 'same-origin',
                                method: 'post' })
      .then(response => response.json())
      .then(order => dispatch({ order, type: 'CREATE_ORDER' }));
  };
}

export function loadOrder(id) {
  return dispatch => {
    fetch(`/api/orders/${id}.json`, { credentials: 'same-origin' })
      .then(response => response.json())
      .then(order => dispatch({ order, type: 'SET_ORDER' }));
  };
}

export function createLineItemForOrder(id, params) {
  return dispatch => {
    params.order.lineItemsAttributes = map(params.order.lineItemsAttributes,
                                           (line) => snakeizeKeys(line));

    params.order = snakeizeKeys(params.order);

    let snakedParams = snakeizeKeys(params);

    fetch(`/api/orders/${id}.json`, { credentials: 'same-origin',
                                      method: 'PATCH',
                                      headers: { 'Content-Type': 'application/json' },
                                      body: JSON.stringify(params) })
      .then(response => response.json())
      .then(order => dispatch({ order, type: 'SET_ORDER' }));
  };
}

export function exportOrders(id) {
  return dispatch => {
    fetch(`/api/orders/export.json`, { credentials: 'same-origin',
                                       method: 'POST',
                                       headers: { 'Content-Type': 'application/json' },
                                       body: JSON.stringify({ id }) })
      .then(response => response.json())
      .then(orders => dispatch(loadOrders()));
  };
}
