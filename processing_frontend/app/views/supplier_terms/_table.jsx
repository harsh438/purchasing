import React from 'react';
import { map, find, matchesProperty } from 'lodash';
import { Link } from 'react-router';

export default class SuppliersTable extends React.Component {
  componentWillMount() {
    this.state = {};
  }

  componentWillReceiveProps(nextProps) {
    this.setState({hasSupplierName: !!find(nextProps.terms||[], (obj) => {
      return !!obj['supplierName'];
    })});
  }

  render() {
    return (
      <table className="table">
        <tbody>
          <tr>
            <th>Created at</th>
            { this.renderSupplierNameTitle() }
            <th>By</th>
            <th>Confirmation file</th>
            <th>View terms</th>
          </tr>
          { map(this.props.terms, this.renderTerm.bind(this)) }
        </tbody>
      </table>);
  }

  renderSupplierNameTitle() {
    if (this.state.hasSupplierName) {
      return (<th>Supplier Name</th>)
    }
  }

  renderTerm(term) {
    return (<tr key={term.id}>
      <td>
        {term.createdAt}
      </td>
        {this.renderSupplierNameRow(term)}
      <td>
        {term.by || <i>Unknown</i>}
      </td>
      <td>
        {this.renderConfirmationFile(term)}
      </td>
      <td>
        <Link to={`/suppliers/term/${term.id}`} >
          View Terms
        </Link>
      </td>
    </tr>);
  }

  renderSupplierNameRow(term = {}) {
    if (this.state.hasSupplierName) {
      return (<td>{term.supplierName}</td>);
    }
  }

  renderConfirmationFile(term) {
    if (term['confirmationFileName']) {
      return (<a href={term['confirmationUrl']} className="btn btn-default" target="_blank">
          <span className="glyphicon glyphicon-cloud-download" aria-hidden="true"></span>&nbsp; Download '{term['confirmationFileName']}'
      </a>);
    } else {
      return <i>No confirmation file</i>
    }
  }
}
