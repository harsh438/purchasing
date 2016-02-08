import { assign, map } from 'lodash';
import { camelizeKeys } from '../utilities/inspection';

const initialState =  { packingLists: {} };

export default function reducePackingLists(state = initialState, action) {
  switch (action.type) {
  case 'SET_PACKING_LISTS':
    const packingLists = map(action.packingLists, camelizeKeys);
    return assign({}, state, { packingLists });
  default:
    return state;
  }
}
