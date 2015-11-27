import { assign, map } from 'lodash';
import { camelizeKeys } from '../utilities/inspection';

const initialState =  { supplier: {}, suppliers: [] };

function transformSupplier(supplier) {
  supplier.defaultTerms = camelizeKeys(supplier.default_terms);
  supplier.terms = map(supplier.terms, camelizeKeys);
  return camelizeKeys(supplier);
}

function transformSuppliers(suppliers) {
  return map(suppliers, transformSupplier);
}

function setSuppliers(state, results) {
  return assign({}, state, { suppliers: transformSuppliers(results.suppliers),
                             totalPages: results.total_pages,
                             activePage: results.page });
}


function setSupplier(state, supplier) {
  return assign({}, state, { supplier: transformSupplier(supplier) });
}

export function reduceSuppliers(state = initialState, action) {
  switch (action.type) {
    case 'LOAD_SUPPLIERS':
      return setSuppliers(state, action.results);
    default:
      return state;
  }
}

export function reduceSupplier(state = initialState, action) {
  switch (action.type) {
    case 'CREATE_SUPPLIER':
      return setSupplier(state, action.supplier);
    case 'SET_SUPPLIER':
      return setSupplier(state, action.supplier);
    default:
      return state;
  }
}
