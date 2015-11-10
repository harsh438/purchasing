import { keys, omit, isEmpty, isNumber } from 'lodash';

function removeEmptyKeys(object) {
  return omit(object, v => !isNumber(v) && isEmpty(v));
}

export function isEmptyObject(object) {
  return keys(omit(object, v => !isNumber(v) && isEmpty(v))).length === 0;
}
