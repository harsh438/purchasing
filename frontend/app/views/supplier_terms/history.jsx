import React from 'react';
import { connect } from 'react-redux';
import { Link } from 'react-router';
import { loadSupplier } from '../../actions/suppliers';
import { assign } from 'lodash';
import { map } from 'lodash';
import SuppliersTable from './_table';

class SupplierTermsHistory extends React.Component {
  componentWillMount () {
    this.props.dispatch(loadSupplier(this.props.params.id));
  }

  render() {
    return (
      <div className="suppliers_terms_history container-fluid"
           style={{ marginTop: '70px' }}>
        <div className="row" style={{ marginBottom: '20px' }}>
          <div className="col-md-8">
            <h1>
              <Link to="/suppliers">Suppliers</Link>
              &nbsp;/&nbsp;
              <Link to={`/suppliers/${this.props.supplier.id}/edit`}>
                {this.props.supplier.name}
              </Link>
              &nbsp;/&nbsp;
              Terms
            </h1>
          </div>
        </div>

        <div className="row">
          <div className="col-md-6">
            <SuppliersTable terms={this.props.supplier.terms} />
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
