import React from 'react';
import { isPlainObject, map } from 'lodash';

export function renderSelectOptions(options) {
  return map(options, function (option) {
    let id, name;

    if (isPlainObject(option)) {
      id = option.id;
      name = option.name;
    } else {
      id = option;
      name = option;
    }

    return (
      <option key={id} value={id}>{name}</option>
    );
  });
}
