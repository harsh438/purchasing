import React from 'react';
import { map } from 'lodash';

export default class SupplierTerms extends React.Component {
  render() {
    return (
      <table className="table">
        {this.renderRows()}
      </table>
    );
  }

  renderRows() {
    return map(this.props.terms, this.renderRow, this);
  }

  renderRow(value, field) {
    return (<tr><th>{field}</th><td>{value}</td></tr>);
  }
}
