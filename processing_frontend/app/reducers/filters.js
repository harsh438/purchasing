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
    case 'SET_BRANDS':
      return Object.assign({}, state, { brands: removeEmpty(action.brands) });
    case 'SET_CATEGORIES':
      return Object.assign({}, state, { categories: removeEmpty(action.categories) });
    case 'SET_GENDERS':
      return Object.assign({}, state, { genders: removeEmpty(action.genders) });
    case 'SET_ORDER_TYPES':
      return Object.assign({}, state, { orderTypes: removeEmpty(action.orderTypes) });
    case 'SET_SEASONS':
      return Object.assign({}, state, { seasons: removeEmpty(action.seasons) });
    case 'SET_SUPPLIERS':
      return Object.assign({}, state, { suppliers: removeEmpty(action.suppliers) });
    default:
      return state;
  }
}
