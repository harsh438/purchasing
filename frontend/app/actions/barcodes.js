import { map, values } from 'lodash';
import { camelizeKeys, snakeizeKeys } from '../utilities/inspection';
import { loadSku } from './skus';

function throwErrors(response) {
  if (response.status < 200 || response.status >= 300) {
    throw "We are experiencing technical difficulties. Support has been notified.";
  } else {
    return response;
  }
}

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

function handleError(dispatch, statefulResultsDispatch) {
  return error => {
    statefulResultsDispatch({ success: false, errors: [error] });
    dispatch({ barcodes: [], type: 'IMPORT_BARCODES' });
  };
}

export function importBarcodes(barcodes, statefulResultsDispatch) {
  return dispatch => {
    fetch(`/api/barcodes/import.json`, { credentials: 'same-origin',
                                         method: 'post',
                                         headers: { 'Content-Type': 'application/json' },
                                         body: JSON.stringify({ barcodes: map(barcodes, snakeizeKeys) }) })
      .then(throwErrors)
      .then(response => response.json())
      .then(handleImportBarcodeResults(dispatch, statefulResultsDispatch))
      .catch(handleError(dispatch, statefulResultsDispatch));
  };
}

export function updateBarcode(barcode) {
  return dispatch => {
    fetch(`/api/barcodes/${barcode.id}.json`, { credentials: 'same-origin',
                                         method: 'PATCH',
                                         headers: { 'Content-Type': 'application/json' },
                                         body: JSON.stringify(barcode) })
      .then(throwErrors)
      .then(response => response.json())
      .then(barcodes => dispatch({ barcodes, type: 'IMPORT_BARCODES' }));
  };
}
