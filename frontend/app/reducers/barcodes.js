import { camelizeKeys } from '../utilities/inspection';
import { assign, map } from 'lodash';

const initialState = { barcodes: [],
                       hasErrors: false,
                       errors: {},
                       nonexistantSkus: [],
                       duplicateBarcodes: [] };

export default function reduceBarcodes(state = initialState, action) {
  switch (action.type) {
  case 'IMPORT_BARCODES':
    if (action.results.errors) {
      return assign({}, state, camelizeKeys(action.results), { hasErrors: true });
    } else {
      return assign({}, state, initialState, { barcodes: map(action.results, camelizeKeys) });
    }
  default:
    return state;
  }
}
