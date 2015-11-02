function setBrands(brands) {
  return { type: 'SET_BRANDS',
           brands: brands };
}

function setGenders(genders) {
  return { type: 'SET_GENDERS',
           genders: genders };
}

function setCategories(categories) {
  return { type: 'SET_CATEGORIES',
           categories: categories };
}

export function loadBrands() {
  return dispatch => {
    fetch('/api/vendors.json', { credentials: 'same-origin' })
      .then(response => response.json())
      .then(brands => dispatch(setBrands(brands)));
  }
}

export function loadGenders() {
  return dispatch => {
    fetch('/api/genders.json', { credentials: 'same-origin' })
      .then(response => response.json())
      .then(genders => dispatch(setGenders(genders)));
  }
}

export function loadCategories() {
  return dispatch => {
    fetch('/api/categories.json', { credentials: 'same-origin' })
      .then(response => response.json())
      .then(categories => dispatch(setCategories(categories)));
  }
}
