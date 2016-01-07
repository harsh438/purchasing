import React from 'react';
import { isPlainObject, map } from 'lodash';
import { Alert } from 'react-bootstrap';

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

export function renderErrors(errors) {
  return (
    <Alert bsStyle="danger">
      <ul>
        {map(errors, (err, i) => {
          return (
            <li key={i}><strong>{err}</strong></li>
          );
        })}
      </ul>
    </Alert>
  );
}
