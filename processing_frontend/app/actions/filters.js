import 'whatwg-fetch';

function loadFilters(type, action) {
  return dispatch => {
    fetch(`/api/filters/${type}.json`, { credentials: 'same-origin' })
      .then(response => response.json())
      .then(filters => dispatch(action(filters)));
  }
}

export function loadBrands() {
  return loadFilters('vendors', brands => ({ brands, type: 'SET_FILTER_BRANDS' }));
}

export function loadCategories() {
  return loadFilters('categories', categories => ({ categories, type: 'SET_FILTER_CATEGORIES' }));
}

export function loadGenders() {
  return loadFilters('genders', genders => ({ genders, type: 'SET_FILTER_GENDERS' }));
}

export function loadOrderTypes() {
  return loadFilters('order_types', orderTypes => ({ orderTypes, type: 'SET_FILTER_ORDER_TYPES' }));
}

export function loadSeasons() {
  return loadFilters('seasons', seasons => ({ seasons, type: 'SET_FILTER_SEASONS' }));
}

export function loadSuppliers() {
  return loadFilters('suppliers', suppliers => ({ suppliers, type: 'SET_FILTER_SUPPLIERS' }));
}
