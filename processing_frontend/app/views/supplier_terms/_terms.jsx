import React from 'react';
import { map, startCase } from 'lodash';

export default class SupplierTerms extends React.Component {
  componentWillMount() {
    this.fields = ['season',
                   'creditLimit',
                   'preOrderDiscount',
                   'creditTermsPreOrder',
                   'reOrderDiscount',
                   'creditTermsReOrder',
                   'faultyReturnsDiscount',
                   'settlementDiscount',
                   'marketingContribution',
                   'rebateStructure',
                   'riskOrderDetails',
                   'markDownContributionDetails',
                   'cancellationAllowance',
                   'stockSwapAllowance',
                   'bulkOrderDetails',
                   'agreedWith',
                   'samples',
                   'productImagery',
                   'by',
                   'comments'];
  }

  render() {
    return (
      <table className="table">
        <tbody>
          {this.renderRows()}
        </tbody>
      </table>
    );
  }

  renderRows() {
    return map(this.fields, this.renderRow, this);
  }

  renderRow(field, i) {
    let value = this.getField(field);

    if (value) {
      return (
        <tr key={i}>
          <th>{startCase(field)}</th>
          <td>{value}</td>
        </tr>
      );
    }
  }

  getField(field) {
    switch (field) {
      case 'samples':
      case 'productImagery':
        return this.props.terms[field] ? '✔' : '✘';
      default:
        return this.props.terms[field];
    }
  }
}
