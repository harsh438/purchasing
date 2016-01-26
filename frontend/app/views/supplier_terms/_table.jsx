import React from 'react';
import { map, find, matchesProperty, camelCase } from 'lodash';
import { Link } from 'react-router';
import SupplierTerms from './_terms';

export default class SuppliersTermsTable extends React.Component {
  render() {
    if (this.props.terms.length === 0) {
      return (
        <p>
          <em>There aren&rsquo;t any terms here</em>
        </p>
      );
    }

    return (
      <table className="table">
        <thead>
          <tr>
            {this.renderSupplierNameTitle()}
            <th>Created at</th>
            <th>Season</th>
            <th>By</th>
            <th>Confirmation file</th>
            {this.renderTermsSelectedTitle()}
          </tr>
        </thead>
        <tbody>
          {map(this.props.terms, this.renderTerm, this)}
        </tbody>
      </table>
    );
  }

  renderSupplierNameTitle() {
    if (this.props.hasSupplierName) {
      return (
        <th>Supplier Name</th>
      );
    }
  }

  renderTermsSelectedTitle() {
    if (this.props.termsSelected.length) {
      return (<th>Terms</th>);
    }
  }

  renderTermsSelectedRow(term) {
    if (this.props.termsSelected.length) {
      return (
        <td>
          <SupplierTerms termsSelected={map(this.props.termsSelected, camelCase)}
                         terms={term} />
        </td>
      );
    }
  }

  renderTerm(term, i) {
    return (
      <tr key={term.id}>
        {this.renderSupplierNameRow(term)}
        <td>
          <Link to={`/suppliers/term/${term.id}`}>
            {term.createdAt}
          </Link>
        </td>
        <td>
          {term.season}
        </td>
        <td>
          {term.by || <i>Unknown</i>}
        </td>
        <td>
          {this.renderConfirmationFile(term)}
        </td>
        {this.renderTermsSelectedRow(term)}
      </tr>
    );
  }

  renderSupplierNameRow(term = {}) {
    if (this.props.hasSupplierName) {
      return (
        <td>
          <Link to={`/suppliers/term/${term.id}`}>{term.supplierName}</Link>
        </td>
      );
    }
  }

  renderConfirmationFile(term) {
    if (term.confirmationFileName) {
      return (
        <a href={term.confirmationUrl}
           target="_blank">
          <span className="glyphicon glyphicon-cloud-download" aria-hidden="true"></span>
          &nbsp; {term.confirmationFileName}
        </a>
      );
    } else {
      return (
        <i>No confirmation file</i>
      );
    }
  }
}
