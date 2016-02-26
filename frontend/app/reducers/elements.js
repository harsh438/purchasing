import { assign } from 'lodash';

const initialState = { elements: [] };

export default function reduceElements(state = initialState, action) {
  switch (action.type) {
  case 'LOAD_ELEMENTS':
    return assign({}, state, { elements: action.elements });
  default:
    return state;
  }
}
