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
                   'agreedWith',
                   'samples',
                   'productImagery',
                   'by',
                   'comments',
                   'confirmationFile'
                   ];
  }

  render() {
    return (
      <table className="table">
        <tbody>
          {this.renderRows()}
          {this.renderParentTerm()}
        </tbody>
      </table>
    );
  }

  renderParentTerm() {
    if (this.props.terms && this.props.terms['parentId']) {
      return (<tr><td colSpan="2">
          <Link className="btn btn-default col-xs-12" to={`/suppliers/term/${this.props.terms['parentId']}`}>
            <span className="glyphicon glyphicon-arrow-left"></span>&nbsp;Go to parent term
          </Link>
        </td></tr>);
    }
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
    let terms = this.props.terms || {};
    switch (field) {
      case 'samples':
      case 'productImagery':
        return terms[field] === '0' ? '✘' : '✔';
      case 'confirmationFile':
        if (terms['confirmationFileName']) {
          return <a href={terms['confirmationUrl']} className="btn btn-default" target="_blank">
            <span className="glyphicon glyphicon-cloud-download" aria-hidden="true"></span>&nbsp;Download '{terms['confirmationFileName']}'
          </a>;
        }
      default:
        return terms[field];
    }
  }
}
