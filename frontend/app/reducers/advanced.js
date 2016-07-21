import { assign } from 'lodash';

function checkForLocalStorage() {
  if (localStorage.getItem('ADVANCED_MODE')) {
    return localStorage.getItem('ADVANCED_MODE');
  } else {
    return false;
  };
}

export default function reduceAdvancedMode(state, action) {
  state = checkForLocalStorage();
  switch (action.type) {
  case 'ADVANCED_MODE':
    return true;
  default:
    return state;
  }
}
