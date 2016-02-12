import { assign, map } from 'lodash';
import { camelizeKeys } from '../utilities/inspection';

const initialState = { users: [] };

export default function reduceUsers(state = initialState, action) {
  switch (action.type) {
  case 'SET_USERS':
    return assign({}, state, { users: map(action.users, camelizeKeys) });
  default:
    return state;
  }
}
