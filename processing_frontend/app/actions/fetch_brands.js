function setBrands(brands) {
  return {
    type: 'SET_BRANDS',
    brands: brands
  };
}

export default function fetchBrands() {
  return dispatch => {
    fetch('/api/vendors.json')
      .then(response => response.json())
      .then(brands => dispatch(setBrands(brands)));
  }
}
