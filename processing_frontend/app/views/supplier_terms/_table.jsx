import React from 'react';
import { map, find, matchesProperty } from 'lodash';
import { Link } from 'react-router';
import SupplierTerms from './_terms';

export default class SuppliersTable extends React.Component {
  componentWillMount() {
    this.state = {};
  }

  componentWillReceiveProps(nextProps) {
    this.setState({hasSupplierName: !!find(nextProps.terms||[], (obj) => {
      return !!obj['supplierName'];
    })});
    if (typeof nextProps.termsAttributes === 'string') {
      this.setState({termsAttributes: nextProps.termsAttributes.split(',')});
    } else {
      this.setState({termsAttributes: nextProps.termsAttributes});
    }
  }

  render() {
    return (
      <table className="table">
        <tbody>
          <tr>
            {this.renderSupplierNameTitle()}
            <th>Created at</th>
            <th>Season</th>
            <th>By</th>
            <th>Confirmation file</th>
            {this.renderTermsAttributeTitle()}
          </tr>
          {map(this.props.terms, this.renderTerm.bind(this))}
        </tbody>
      </table>
    );
  }

  renderSupplierNameTitle() {
    if (this.state.hasSupplierName) {
      return (
        <th>Supplier Name</th>
      );
    }
  }

  renderTermsAttributeTitle() {
    if (this.state.termsAttributes) {
      return (<th>Terms</th>);
    }
  }

  renderTermsAttributeRow(term) {
    if (this.state.termsAttributes) {
      return (<td><SupplierTerms fieldList={this.state.termsAttributes} terms={term} /></td>);
    }
  }

  renderTerm(term) {
    return (
      <tr key={term.id}>
        {this.renderSupplierNameRow(term)}
        <td>
          <Link to={`/suppliers/term/${term.id}`} >
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
          {this.renderTermsAttributeRow(term)}
      </tr>
    );
  }

  renderSupplierNameRow(term = {}) {
    if (this.state.hasSupplierName) {
      return (
        <td>{term.supplierName}</td>
      );
    }
  }

  renderConfirmationFile(term) {
    if (term['confirmationFileName']) {
      return (
        <a href={term['confirmationUrl']}
           target="_blank">
          <span className="glyphicon glyphicon-cloud-download" aria-hidden="true"></span>&nbsp; Download '{term['confirmationFileName']}'
        </a>
      );
    } else {
      return (
        <i>No confirmation file</i>
      );
    }
  }
}
