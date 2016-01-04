import { assign, map } from 'lodash';
import { camelizeKeys } from '../utilities/inspection';

const initialState = { skus: [],
                       totalPages: null,
                       activePage: null,
                       sku: {} };

export default function reduceSkus(state = initialState, action) {
  switch (action.type) {
  case 'LOAD_SKUS':
    return assign({}, state, { skus: map(action.results.skus, camelizeKeys),
                               activePage: action.results.active_page,
                               totalPages: action.results.total_pages });
  case 'LOAD_SKU':
    return assign({}, state, { sku: camelizeKeys(action.sku) });
  default:
    return state;
  }
}
