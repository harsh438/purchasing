import { assign, map } from 'lodash';
import { camelizeKeys } from '../utilities/inspection';

const initialState = { skus: [],
                       totalPages: null,
                       activePage: null };

export default function reduceSkus(state = initialState, action) {
  switch (action.type) {
  case 'LOAD_SKUS':
    console.log(action.results);
    return assign({}, state, { skus: map(action.results.skus, camelizeKeys),
                               activePage: action.results.active_page,
                               totalPages: action.results.total_pages });
  default:
    return state;
  }
}
