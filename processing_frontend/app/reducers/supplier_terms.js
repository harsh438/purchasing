import { assign } from 'lodash';

export function reduceSupplierTerms(state = {}, action) {
  switch (action.type) {
    case 'SET_TERMS':
      return assign({}, state, {terms: action.results});
    default:
      return state;
  }
}
