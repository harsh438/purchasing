import { camelizeKeys } from '../utilities/inspection';
import { assign, map } from 'lodash';

const initialState = { barcodes: [] };

export default function reduceBarcodes(state = initialState, action) {
  switch (action.type) {
  case 'IMPORT_BARCODES':
    return assign({}, state, { barcodes: action.barcodes });
  default:
    return state;
  }
}
