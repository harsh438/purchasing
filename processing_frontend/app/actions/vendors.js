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
