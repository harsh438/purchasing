import React from 'react';
import Qs from 'qs';
import 'whatwg-fetch';
import { map } from 'lodash'
import { snakeizeKeys } from '../utilities/inspection'

export function loadOrders(page) {
  return dispatch => {
    const queryString = Qs.stringify({ page });
    fetch(`/api/orders.json?${queryString}`, { credentials: 'same-origin' })
      .then(response => response.json())
      .then(results => dispatch({ results, type: 'SET_ORDERS' }));
  };
}

export function createOrder(params = {}) {
  return dispatch => {
    fetch(`/api/orders.json`, { credentials: 'same-origin',
                                method: 'post',
                                headers: { 'Content-Type': 'application/json' },
                                body: JSON.stringify({ order: params }) })
      .then(response => response.json())
      .then(results => dispatch({ results, type: 'CREATE_ORDER' }));
  };
}

export function loadOrder(id) {
  return dispatch => {
    fetch(`/api/orders/${id}.json`, { credentials: 'same-origin' })
      .then(response => response.json())
      .then(results => dispatch({ results, type: 'SET_ORDER' }));
  };
}

export function createLineItemsForOrder(id, params) {
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
      .then(results => dispatch({ results, type: 'SET_ORDER' }));
  };
}

export function updateLineItem(id, params = {}) {
  return dispatch => {
    fetch(`/api/order_line_items/${id}.json`, { credentials: 'same-origin',
                                                method: 'PATCH',
                                                headers: { 'Content-Type': 'application/json' },
                                                body: JSON.stringify(params) })
      .then(response => response.json())
      .then(results => dispatch({ results, type: 'SET_ORDER' }));
  }
}

export function deleteLineItem(id) {
  return dispatch => {
    fetch(`/api/order_line_items/${id}.json`, { credentials: 'same-origin',
                                                method: 'DELETE',
                                                headers: { 'Content-Type': 'application/json' } })
      .then(response => response.json())
      .then(ids => dispatch({ ids, type: 'DELETE_LINE_ITEM' }));
  }
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
