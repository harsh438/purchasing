import React from 'react';
import { connect } from 'react-redux';
import { assign } from 'lodash';

export default class SuppliersIndex extends React.Component {
  componentWillMount() {
  }

  render() {
    return (
      <div className="suppliers_index">
        Cool
      </div>
    );
  }
}

function applyState({ filters, suppliers }) {
  return assign({}, filters, suppliers);
}

export default connect(applyState)(SuppliersIndex);
