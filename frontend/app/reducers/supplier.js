import { assign, map } from 'lodash';
import { camelizeKeys } from '../utilities/inspection';

const initialState = { supplier: { contacts: [],
                                   buyers: [],
                                   vendors: [],
                                   terms: [] },
                       suppliers: [],
                       totalPages: null,
                       activePage: null };

function transformSupplier(supplier) {
  supplier.defaultTerms = camelizeKeys(supplier.default_terms);
  supplier.terms = map(supplier.terms, camelizeKeys);
  supplier.contacts = map(supplier.contacts, camelizeKeys);
  supplier.buyers = map(supplier.buyers, camelizeKeys);
  return camelizeKeys(supplier);
}

function setSuppliers(state, results) {
  return assign({}, state, { suppliers: map(results.suppliers, transformSupplier),
                             totalPages: results.total_pages,
                             activePage: results.page });
}

function setSupplier(state, supplier) {
  return assign({}, state, { supplier: transformSupplier(supplier) });
}

export default function reduceSuppliers(state = initialState, action) {
  switch (action.type) {
  case 'LOAD_SUPPLIERS':
    return setSuppliers(state, action.results);
  case 'CREATE_SUPPLIER':
    return setSupplier(state, action.supplier);
  case 'SET_SUPPLIER':
    return setSupplier(state, action.supplier);
  default:
    return state;
  }
}
