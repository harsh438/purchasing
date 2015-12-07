import { assign, pluck, camelCase, map } from 'lodash';

const initialState = { brands: [],
                       categories: [],
                       genders: [],
                       orderTypes: [],
                       seasons: [],
                       suppliers: [] };

function removeEmpty(filters) {
  return filters.filter(function (filter) {
    return filter.id && filter.name;
  });
}

export default function reduceFilters(state = initialState, action) {
  switch (action.type) {
  case 'SET_FILTER_BRANDS':
    return assign({}, state, { brands: removeEmpty(action.brands) });
  case 'SET_FILTER_CATEGORIES':
    return assign({}, state, { categories: removeEmpty(action.categories) });
  case 'SET_FILTER_GENDERS':
    return assign({}, state, { genders: removeEmpty(action.genders) });
  case 'SET_FILTER_ORDER_TYPES':
    return assign({}, state, { orderTypes: removeEmpty(action.orderTypes) });
  case 'SET_FILTER_SEASONS':
    return assign({}, state, { seasons: removeEmpty(action.seasons) });
  case 'SET_FILTER_SUPPLIERS':
    return assign({}, state, { suppliers: removeEmpty(action.suppliers) });
  case 'SET_FILTER_BUYERS':
    return assign({}, state, { buyers: pluck(removeEmpty(action.buyers), 'name') });
  case 'SET_FILTER_BUYER_ASSISTANTS':
    return assign({}, state, { buyerAssistants: pluck(removeEmpty(action.buyerAssistants), 'name') });
  case 'SET_SUPPLIER_TERMS_LIST':
    return assign({}, state, { supplierTermsList: map(action.supplierTermsList, camelCase) });
  default:
    return state;
  }
}
