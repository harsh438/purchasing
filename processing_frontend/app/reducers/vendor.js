import { assign, map } from 'lodash';
import { camelizeKeys } from '../utilities/inspection';

const initialState =  { vendor: {}, vendors: [] };

function transformVendor(vendor) {
  return camelizeKeys(vendor);
}

function setVendor(state, vendor) {
  return assign({}, state, { vendor: transformVendor(vendor) });
}

export function reduceVendor(state = initialState, action) {
  switch (action.type) {
    case 'CREATE_VENDOR':
      return setVendor(state, action.vendor);
    default:
      return state;
  }
}
