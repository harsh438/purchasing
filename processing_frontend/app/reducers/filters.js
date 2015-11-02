const initialState = { brands: [], categories: [], genders: [] };

function removeEmpty(filters) {
  return filters.filter(function (filter) {
    return filter.id && filter.name;
  });
}

export default function reduceFilters(state = initialState, action) {
  switch (action.type) {
    case 'SET_GENDERS':
      return Object.assign({}, state, { genders: removeEmpty(action.genders) });
    case 'SET_BRANDS':
      return Object.assign({}, state, { brands: removeEmpty(action.brands) });
    case 'SET_CATEGORIES':
      return Object.assign({}, state, { categories: removeEmpty(action.categories) });
    default:
      return state;
  }
}
