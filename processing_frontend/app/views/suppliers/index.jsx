import React from 'react';
import { Link } from 'react-router';
import { connect } from 'react-redux';
import { assign } from 'lodash';
import SuppliersTable from './_table';
import NumberedPagination from '../pagination/_numbered';
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
                  Add New Supplier
                </Link>

                <hr />

                <SuppliersTable suppliers={this.props.suppliers}
                                onEditSupplierButton={this.handleClickEditSupplier.bind(this)} />

        				<NumberedPagination activePage={this.props.activePage}
                                    index={this.props.index}
                                    totalPages={this.props.totalPages} />
              </div>
            </div>
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
