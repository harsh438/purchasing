const initialState = { brands: [], categories: [] };

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
    default:
      return state;
  }
}
