import React from 'react';
import { loadSupplier } from '../../actions/suppliers';
import { connect } from 'react-redux';
import { assign } from 'lodash';
import { map } from 'lodash';
import { Link } from 'react-router';

class SupplierTermsHistory extends React.Component {
  componentWillMount () {
    this.state = {id: this.props.params.id};
    this.props.dispatch(loadSupplier(this.props.params.id));
  }



  render() {
    return (
      <div className="suppliers_terms_history" style={{ marginTop: '70px' }}>
        <div className="col-md-12">
            <div className="panel panel-default">
              <div className="panel-heading" style={{ overflow: 'hidden'}}>
                <h3 className="panel-title pull-left">
                  Terms history
                </h3>
              <Link className="pull-right" to={`/suppliers/${this.state.id}/edit`}>
                <span className="glyphicon glyphicon-arrow-left"></span>&nbsp;Go back to supplier page
              </Link>
              </div>
              <div className="panel-body">
              <h4>History Terms for { this.props.supplier.name }</h4>
                { this.renderTerms() }
              </div>
            </div>
          </div>
      </div>
    )
  }

  renderTerms() {
    return (
      <table className="table">
        <tbody>
          <tr>
            <th>Created at</th>
            <th>By</th>
            <th>Confirmation file</th>
            <th>View terms</th>
          </tr>
          { map(this.props.supplier.terms, this.renderTerm.bind(this)) }
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



function applyState({ supplier }) {
  return assign({}, supplier);
}

export default connect(applyState)(SupplierTermsHistory);
