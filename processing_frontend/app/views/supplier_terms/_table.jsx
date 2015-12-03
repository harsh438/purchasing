import React from 'react';
import { map } from 'lodash';
import { Link } from 'react-router';

export default class SuppliersTable extends React.Component {
  render() {
    return (
      <table className="table">
        <tbody>
          <tr>
            <th>Created at</th>
            <th>By</th>
            <th>Confirmation file</th>
            <th>View terms</th>
          </tr>
          { map(this.props.terms, this.renderTerm.bind(this)) }
        </tbody>
      </table>);
  }

  renderTerm(term) {
    return (<tr key={term.id}>
      <td>
        {term.createdAt}
      </td>
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
