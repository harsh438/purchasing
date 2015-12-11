import { assign, map } from 'lodash';
import { camelizeKeys } from '../utilities/inspection';

const initialState = { supplierTerms: {} };

export function reduceSupplierTerms(state = initialState, action) {
  switch (action.type) {
  case 'SET_SUPPLIER_TERMS':
    return assign({}, state, { supplierTerms: camelizeKeys(action.results) });
  default:
    return state;
  }
}

export function reduceTerms(state = initialState, action) {
  switch (action.type) {
  case 'LOAD_TERMS':
    return assign({}, state, { terms: map(action.results.terms, camelizeKeys),
                               totalPages: action.results.total_pages,
                               activePage: action.results.page });
  default:
    return state;
  }
}
