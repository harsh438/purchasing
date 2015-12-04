import { assign, map } from 'lodash';
import { camelizeKeys } from '../utilities/inspection';

const initialSupplierState = { supplier: { contacts: [],
                                           buyers: [],
                                           vendors: [] } };

const initialSuppliersState = { supplier: { contacts: [],
                                            buyers: [],
                                            vendors: [] },
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

export function reduceSupplierNames(state = initialSuppliersState, action) {
  switch (action.type) {
  case 'LOAD_SUPPLIER_NAMES':
    return setSuppliers(state, action.results);
  default:
    return state;
  }
}

export function reduceSuppliers(state = initialSuppliersState, action) {
  switch (action.type) {
  case 'LOAD_SUPPLIERS':
    return setSuppliers(state, action.results);
  default:
    return state;
  }
}

export function reduceSupplier(state = initialSupplierState, action) {
  switch (action.type) {
  case 'CREATE_SUPPLIER':
    return setSupplier(state, action.supplier);
  case 'SET_SUPPLIER':
    return setSupplier(state, action.supplier);
  default:
    return state;
  }
}
