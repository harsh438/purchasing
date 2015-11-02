function setBrands(brands) {
  return { type: 'SET_BRANDS',
           brands: brands };
}

function setSuppliers(suppliers) {
  return { type: 'SET_SUPPLIERS',
           suppliers: suppliers };
}

function setGenders(genders) {
  return { type: 'SET_GENDERS',
           genders: genders };
}

function setOrderTypes(orderTypes) {
  return { type: 'SET_ORDER_TYPES',
           orderTypes: orderTypes };
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

export function loadOrderTypes() {
  return dispatch => {
    fetch('/api/order_types.json', { credentials: 'same-origin' })
      .then(response => response.json())
      .then(orderTypes => dispatch(setOrderTypes(orderTypes)));
  }
}

export function loadCategories() {
  return dispatch => {
    fetch('/api/categories.json', { credentials: 'same-origin' })
      .then(response => response.json())
      .then(categories => dispatch(setCategories(categories)));
  }
}

export function loadSuppliers() {
  return dispatch => {
    fetch('/api/suppliers.json', { credentials: 'same-origin' })
      .then(response => response.json())
      .then(suppliers => dispatch(setSuppliers(suppliers)));
  }
}
