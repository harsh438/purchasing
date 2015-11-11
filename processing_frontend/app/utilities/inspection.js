import { keys, omit, isEmpty, isNumber, mapKeys, rearg, camelCase, snakeCase } from 'lodash';

export const camelizeKeys = obj => mapKeys(obj, rearg(camelCase, [1, 0]));
export const snakeizeKeys = obj => mapKeys(obj, rearg(snakeCase, [1, 0]));

export function removeEmptyKeys(object) {
  return omit(object, v => !isNumber(v) && isEmpty(v));
}

export function isEmptyObject(object) {
  return keys(omit(object, v => !isNumber(v) && isEmpty(v))).length === 0;
}
