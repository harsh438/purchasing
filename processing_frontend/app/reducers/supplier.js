import { assign, map } from 'lodash';
import { camelizeKeys } from '../utilities/inspection';

const initialState =  { supplier: {}, suppliers: [] };

function transformSupplier(supplier) {
  return camelizeKeys(supplier);
}

function transformSuppliers(orders) {
  return map(orders, (o) => camelizeKeys(o));
}

function setSuppliers(state, results) {
  results = camelizeKeys(results)
  results.orders = transformSuppliers(results.suppliers);
  return assign({}, { suppliers: results.suppliers,
                             totalPages: results.totalPages,
                             activePage: results.page });
}


function setSupplier(state, action) {
  return assign({}, { supplier: transformSupplier(action.results) });
}

export function reduceSuppliers(state = initialState, action) {
  switch (action.type) {
    case 'CREATE_SUPPLIER':
      return setSupplier(state, action);
    case 'LOAD_SUPPLIERS':
      return setSuppliers(state, action.results);
    default:
      return state;
  }
}

export function reduceSupplier(state = initialState, action) {
  switch (action.type) {
    case 'SET_SUPPLIER':
      return setSupplier(state, action);
    default:
      return state;
  }
}
