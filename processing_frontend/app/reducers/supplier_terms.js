import { assign } from 'lodash';
import { camelizeKeys } from '../utilities/inspection';

export function reduceSupplierTerms(state = {}, action) {
  switch (action.type) {
  case 'SET_TERMS':
    return assign({}, state, {terms: camelizeKeys(action.results)});
  default:
    return state;
  }
}
