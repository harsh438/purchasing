import React from 'react';
import { map, startCase } from 'lodash';
import { Link } from 'react-router';

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
                   'saleOrReturnDetails',
                   'agreedWith',
                   'samples',
                   'productImagery',
                   'by',
                   'comments',
                   'confirmationFile'];
  }

  render() {
    return (
      <table className="table">
        <tbody>
          {map(this.props.termsSelected || this.fields, this.renderRow, this)}
        </tbody>
      </table>
    );
  }

  renderRow(field, i) {
    let attrs;

    if (i === 0) {
      attrs = { style: { border: '0' } };
    } else {
      attrs = {};
    }

    return (
      <tr key={i}>
        <th {...attrs}>{startCase(field)}</th>
        <td {...attrs}>{this.getField(field)}</td>
      </tr>
    );
  }

  getField(field) {
    let terms = this.props.terms || {};

    switch (field) {
    case 'samples':
    case 'productImagery':
      return terms[field] ? '✔' : '✘';
    case 'marketingContribution':
      return `${terms[field].percentage}% of ${startCase(terms[field].of)}`;
    case 'confirmationFile':
      if (terms.confirmationFileName) {
        return (
          <a href={terms.confirmationUrl}
             target="_blank">
            <span className="glyphicon glyphicon-cloud-download" aria-hidden="true"></span>
            &nbsp; {terms.confirmationFileName}
          </a>
        );
      }
    default:
      return terms[field];
    }
  }
}
