import { assign } from 'lodash';

export default function reduceNotification(state = {}, action) {
  const notificationType = {
    'SUCCESS_NOTIFICATION': 'success',
    'ERROR_NOTIFICATION': 'error',
  };

  switch (action.type) {
  case 'SUCCESS_NOTIFICATION':
  case 'ERROR_NOTIFICATION':
    return assign({}, state, {
      notification: {
        type: notificationType[action.type],
        text: action.text,
        date: new Date().toISOString(),
      },
    });
  default:
    return state;
  }
}
