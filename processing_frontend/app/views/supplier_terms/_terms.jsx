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
          {map(this.fields, this.renderRow, this)}
        </tbody>
      </table>
    );
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
    let terms = this.props.terms || {};

    switch (field) {
    case 'samples':
    case 'productImagery':
      return terms[field] ? '✔' : '✘';
    case 'confirmationFile':
      if (terms.confirmationFileName) {
        return (
          <a href={terms.confirmationUrl}
             className="btn btn-default"
             target="_blank">
            <span className="glyphicon glyphicon-cloud-download" aria-hidden="true"></span>
            &nbsp;Download {terms.confirmationFileName}
          </a>
        );
      }
    default:
      return terms[field];
    }
  }
}
