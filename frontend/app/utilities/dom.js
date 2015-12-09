import React from 'react';
import { isPlainObject, map } from 'lodash';

function optionHashes(options) {
  return map(options, function (option) {
    let id, name;

    if (isPlainObject(option)) {
      id = option.id;
      name = option.name;
    } else {
      id = option;
      name = option;
    }

    return { id, name };
  });
}

export function renderSelectOptions(options) {
  return map(optionHashes(options), function ({ id, name }) {
    return (
      <option key={id} value={id}>{name}</option>
    );
  });
}

export function renderMultiSelectOptions(options) {
  return map(optionHashes(options), function ({ id, name }) {
    return { value: id, label: name };
  });
}
