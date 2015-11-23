import { assign } from 'lodash';
import { camelizeKeys } from '../utilities/inspection';

const initialState =  { supplier: {} };

function transformSupplier(supplier) {
  return camelizeKeys(supplier);
}

function setSupplier(state, action) {
  console.log(action);
  return assign({}, state, { supplier: transformSupplier(action.results) });
}

export default function reduceSupplier(state = initialState, action) {
  switch (action.type) {
    case 'CREATE_SUPPLIER':
      return setSupplier(state, action);
    default:
      return state;
  }
}
