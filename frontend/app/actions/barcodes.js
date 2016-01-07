import { values } from 'lodash';
import { camelizeKeys } from '../utilities/inspection';

function handleImportBarcodeResults(dispatch, statefulResultsDispatch) {
  return results => {
    if (results.errors) {
      results.errors = values(results.errors);
      statefulResultsDispatch({ success: false, ...camelizeKeys(results) });
      dispatch({ barcodes: [], type: 'IMPORT_BARCODES' });
    } else {
      statefulResultsDispatch({ success: true, errors: [] });
      dispatch({ barcodes: results, type: 'IMPORT_BARCODES' });
    }
  };
}

export function importBarcodes(barcodes, statefulResultsDispatch) {
  return dispatch => {
    fetch(`/api/barcodes/import.json`, { credentials: 'same-origin',
                                         method: 'post',
                                         headers: { 'Content-Type': 'application/json' },
                                         body: JSON.stringify({ barcodes }) })
      .then(response => response.json())
      .then(handleImportBarcodeResults(dispatch, statefulResultsDispatch));
  };
}
