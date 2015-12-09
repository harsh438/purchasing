import React from 'react';
import { loadSupplier } from '../../actions/suppliers';
import { connect } from 'react-redux';
import { assign } from 'lodash';
import { map } from 'lodash';
import { Link } from 'react-router';
import SuppliersTable from './_table';

class SupplierTermsHistory extends React.Component {
  componentWillMount () {
    this.props.dispatch(loadSupplier(this.props.params.id));
  }

  render() {
    return (
      <div className="suppliers_terms_history" style={{ marginTop: '70px' }}>
        <div className="col-md-12">
            <div className="panel panel-default">
              <div className="panel-heading" style={{ overflow: 'hidden' }}>
                <h3 className="panel-title pull-left">
                  Terms history for {this.props.supplier.name}
                </h3>

                <Link className="pull-right" to={`/suppliers/${this.props.params.id}/edit`}>
                  <span className="glyphicon glyphicon-arrow-left"></span>
                  &nbsp; Go back to supplier page
                </Link>
              </div>
              <div className="panel-body">
                <SuppliersTable terms={this.props.supplier.terms} />
              </div>
            </div>
          </div>
      </div>
    );
  }
}



function applyState({ supplier }) {
  return assign({}, supplier);
}

export default connect(applyState)(SupplierTermsHistory);
