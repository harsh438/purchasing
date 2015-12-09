import { assign, map } from 'lodash';
import { camelizeKeys } from '../utilities/inspection';

const initialVendorState =  { vendor: { suppliers: [] } };
const initialVendorsState = { vendors: [], activePage: null, totalPages: null };

function transformVendor(vendor) {
  return camelizeKeys(vendor);
}

function setVendor(state, vendor) {
  return assign({}, state, { vendor: transformVendor(vendor) });
}

function setVendors(state, results) {
  return assign({}, state, { vendors: map(results.vendors, transformVendor),
                             activePage: results.page,
                             totalPages: results.total_pages });
}

export function reduceVendor(state = initialVendorState, action) {
  switch (action.type) {
  case 'CREATE_VENDOR':
    return setVendor(state, action.vendor);
  case 'SET_VENDOR':
    return setVendor(state, action.vendor);
  default:
    return state;
  }
}

export function reduceVendors(state = initialVendorsState, action) {
  switch (action.type) {
  case 'SET_VENDORS':
    return setVendors(state, action.results);
  default:
    return state;
  }
}
