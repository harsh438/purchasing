import React from 'react';
import { Link } from 'react-router';
import { connect } from 'react-redux';
import { assign, isEqual } from 'lodash';
import SuppliersTable from './_table';
import SuppliersFilters from './_filters';
import NumberedPagination from '../pagination/_numbered';
import { loadBrands } from '../../actions/filters';
import { loadSuppliers } from '../../actions/suppliers';

class SuppliersIndex extends React.Component {
  componentWillMount() {
    this.loadPage();
    this.props.dispatch(loadBrands());
  }

  componentWillReceiveProps(nextProps) {
    const nextQuery = nextProps.location.query;

    if (!isEqual(this.props.location.query, nextQuery)) {
      this.loadPage(nextQuery);
    }
  }

  render() {
    return (
      <div className="suppliers_index  container-fluid"
           style={{ marginTop: '70px' }}>
        <div className="row">
          <div className="col-md-12">
          	<div className="panel panel-default">
        			<div className="panel-body">
                <SuppliersFilters filters={this.props.location.query.filters}
                                  brands={this.props.brands}
                                  onFilterSuppliers={this.handleFilterSuppliers.bind(this)} />
              </div>
            </div>
          </div>
        </div>

        <div className="row">
          <div className="col-md-12">
          	<div className="panel panel-default">
        			<div className="panel-body">
                <Link to="/suppliers/new"
                      className="btn btn-success">
                  Add New Supplier
                </Link>

                <hr style={{ clear: 'both' }} />

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

  loadPage(query = this.props.location.query) {
    const { filters, page } = query;
    this.props.dispatch(loadSuppliers({ filters, page }));
  }

  handleClickEditSupplier(id) {
    this.props.history.pushState(null, `/suppliers/${id}/edit`);
  }

  handleFilterSuppliers(filters) {
    this.props.history.pushState(null, '/suppliers', { filters });
  }
}

function applyState({ filters, suppliers, supplier }) {
  return assign({}, filters, supplier, suppliers);
}

export default connect(applyState)(SuppliersIndex);
