const initialState = [];

export default function reduceCategories(state = initialState, action) {
  switch (action.type) {
    case 'SET_CATEGORIES':
      return action.categories;
    default:
      return state;
  }
}
