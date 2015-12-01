export function loadTerms(id) {
  return dispatch => {
    fetch(`/api/supplier_terms/${id}.json`, { credentials: 'same-origin' })
      .then(response => response.json())
      .then(results => dispatch({ results, type: 'SET_TERMS' }));
  };
}
