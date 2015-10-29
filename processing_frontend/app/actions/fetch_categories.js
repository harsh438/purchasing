function setCategories(categories) {
  return {
    type: 'SET_CATEGORIES',
    categories: categories
  };
}

export default function fetchCategories() {
  return dispatch => {
    fetch('/api/categories.json')
      .then(response => response.json())
      .then(categories => dispatch(setCategories(categories)));
  }
}
