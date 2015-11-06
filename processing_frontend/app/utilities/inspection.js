import { keys, omit, isEmpty, isNumber } from 'lodash';

export function isEmptyObject(object) {
  return keys(omit(object, v => !isNumber(v) && isEmpty(v))).length === 0;
}
