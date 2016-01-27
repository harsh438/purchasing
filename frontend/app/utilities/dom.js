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

function renderFlashes(type, messages) {
  return (
    <Alert bsStyle={type}>
      <ul>
        {map(messages, (err, i) => {
          return (
            <li key={i}><strong>{err}</strong></li>
          );
        })}
      </ul>
    </Alert>
  );
}

export function renderErrors(errors) {
  return renderFlashes('danger', errors);
}

export function renderSuccesses(messages) {
  return renderFlashes('success', messages);
}

export function renderCsvExportLink(url, options = {}) {
  const { disabled, text } = { text: 'Export as CSV', disabled: false, ...options };
  
  return (
    <a href={url}
       className="btn btn-default"
       target="_blank"
       disabled={disabled}>
      <span className="glyphicon glyphicon-cloud-download" aria-hidden="true"></span>
      &nbsp;{text}
    </a>
  );
}
