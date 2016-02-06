import { assign } from 'lodash';

export default function reduceAdvancedMode(state = false, action) {
  switch (action.type) {
  case 'ADVANCED_MODE':
    return true;
  default:
    return false;
  }
}
