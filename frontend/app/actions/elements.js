export function loadElements(query) {
  return dispatch => {
    fetch(`/api/elements.json`, { credentials: 'same-origin' })
      .then(response => response.json())
      .then(results => dispatch({ elements: results.elements, type: 'LOAD_ELEMENTS' }))
      .catch(() => {
        dispatch({ text: 'Unable to load Surfdome sizes.', type: 'ERROR_NOTIFICATION' });
      });
  };
}
