import { assign } from 'lodash';

export default function reduceErrorNotification(state = {}, action) {
  switch (action.type) {
  case 'ERROR_NOTIFICATION':
    return assign({}, state, {
      errorNotification: { text: action.text, date: new Date().toISOString() },
    });
  default:
    return state;
  }
}
