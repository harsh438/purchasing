import { assign, map } from 'lodash';
import { camelizeKeys } from '../utilities/inspection';

const initialState = { supplierTerms: [],
                       singleSupplierTerms: {} };

export default function reduceSupplierTerms(state = initialState, action) {
  switch (action.type) {
  case 'LOAD_SUPPLIER_TERMS':
    return assign({}, state, { supplierTerms: map(action.results.terms, camelizeKeys),
                               totalPages: action.results.total_pages,
                               activePage: action.results.page });
  case 'LOAD_SINGLE_SUPPLIER_TERMS':
    return assign({}, state, { singleSupplierTerms: camelizeKeys(action.results) });
  default:
    return state;
  }
}
