import React from 'react';
import { Link } from 'react-router';
import { connect } from 'react-redux';
import { assign } from 'lodash';
import { SuppliersTable } from './_table';
import { loadSuppliers } from '../../actions/suppliers';

class SuppliersIndex extends React.Component {
  componentWillMount() {
    this.loadPage(this.props.location.query.page);
  }

  render() {
    return (
      <div className="suppliers_index  container-fluid"
           style={{ marginTop: '70px' }}>
        <div className="row">
          <div className="col-md-12">
            <div className="panel panel-default">
              <div className="panel-body">
                <Link to="/suppliers/new"
                      className="btn btn-success">
                  Add Supplier
                </Link>
              </div>
            </div>
          </div>
        </div>

        <div className="row">
          <div className="col-md-12">
            <SuppliersTable index={this}
                            suppliers={this.props.suppliers}
                            totalPages={this.props.totalPages}
                            activePage={this.props.activePage}
                            onEditSupplierButton={this.handleClickEditSupplier.bind(this)} />
          </div>
        </div>
      </div>
    );
  }

  loadPage(page) {
    this.props.dispatch(loadSuppliers(page || 1));
  }

  handleClickEditSupplier(id) {
    this.props.history.pushState(null, `/suppliers/${id}/edit`);
  }
}

function applyState({ suppliers, supplier }) {
  return assign({}, supplier, suppliers);
}

export default connect(applyState)(SuppliersIndex);
