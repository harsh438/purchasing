import React from 'react';
import { loadSupplier } from '../../actions/suppliers';
import { connect } from 'react-redux';
import { assign } from 'lodash';
import { map } from 'lodash';

class SupplierTermsHistory extends React.Component {
  componentWillMount () {
    this.state = {};
    this.props.dispatch(loadSupplier(this.props.params.id));
  }



  render() {
    console.log(this.props.supplier);
    return (
      <div className="suppliers_edit" style={{ marginTop: '70px' }}>
          <div className="panel panel-default">
            <div className="panel-heading">
              <h3 className="panel-title">Terms History</h3>
            </div>
            <div className="panel-body">
              { this.renderTerms() }
            </div>
          </div>
      </div>
    )
  }

  renderTerms() {
    console.log(this.props.supplier.terms);
    return (
      <table className="table">
        <tbody>
          <tr>
            <th>Created At</th>
            <th>By</th>
            <th>Confirmation File</th>
            <th>View Terms</th>
          </tr>
          { map(this.props.supplier.terms, this.renderTerm.bind(this)) }
        </tbody>
      </table>);
  }

  renderTerm(term) {
    console.log('fff', term)
    return (<tr key={term.id}>
      <td>
        {term.createdAt}
      </td>
      <td>
        {term.by}
      </td>
      <td>
        {this.renderConfirmationFile(term)}
      </td>
      <td>
        View Terms
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



function applyState({ supplier }) {
  console.log(supplier);
  return assign({}, supplier);
}

export default connect(applyState)(SupplierTermsHistory);
