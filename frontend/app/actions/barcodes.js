export function importBarcodes(barcodes) {
  return dispatch => {
    fetch(`/api/barcodes/import.json`, { credentials: 'same-origin',
                                         method: 'post',
                                         headers: { 'Content-Type': 'application/json' },
                                         body: JSON.stringify({ barcodes }) })
      .then(response => response.json())
      .then(results => dispatch({ results, type: 'IMPORT_BARCODES' }));
  };
}
