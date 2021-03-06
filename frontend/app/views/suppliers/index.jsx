import React from 'react';
import { Link } from 'react-router';
import { connect } from 'react-redux';
import { assign, isEqual } from 'lodash';
import SuppliersTable from './_table';
import SuppliersFilters from './_filters';
import NumberedPagination from '../pagination/_numbered';
import { loadVendors,
         loadBuyers,
         loadBuyerAssistants } from '../../actions/filters';
import { loadSuppliers } from '../../actions/suppliers';

class SuppliersIndex extends React.Component {
  componentWillMount() {
    this.loadPage();
    this.props.dispatch(loadVendors());
    this.props.dispatch(loadBuyers());
    this.props.dispatch(loadBuyerAssistants());
  }

  componentWillReceiveProps(nextProps) {
    const nextQuery = nextProps.location.query;

    if (!isEqual(this.props.location.query, nextQuery)) {
      this.loadPage(nextQuery.page, (nextQuery.filters || {}));
    }
  }

  render() {
    return (
      <div className="suppliers_index container-fluid"
           style={{ marginTop: '70px' }}>
        <div className="row" style={{ marginBottom: '20px' }}>
          <div className="col-md-4">
            <h1>Suppliers</h1>
          </div>

          <div className="col-md-2 col-md-offset-6 text-right">
            <Link to="/suppliers/new"
                  className="btn btn-success">
              Add New Supplier
            </Link>
          </div>
        </div>

        <div className="row">
          <div className="col-md-12">
          	<div className="panel panel-default">
        			<div className="panel-body">
                <SuppliersFilters filters={this.props.location.query.filters}
                                  brands={this.props.brands}
                                  buyers={this.props.buyers}
                                  buyerAssistants={this.props.buyerAssistants}
                                  onFilterSuppliers={this.handleFilterSuppliers.bind(this)} />

              </div>
            </div>

            <SuppliersTable suppliers={this.props.suppliers}/>

            <NumberedPagination activePage={this.props.activePage || 1}
                                index={this}
                                totalPages={this.props.totalPages} />
          </div>
        </div>
      </div>
    );
  }

  loadPage(page = this.props.location.query.page, filters = this.props.location.query.filters) {
    this.props.dispatch(loadSuppliers({ filters, page }));
  }

  handleFilterSuppliers(filters) {
    this.props.history.pushState(null, '/suppliers', { filters });
  }
}

function applyState({ filters, suppliers }) {
  return assign({}, filters, suppliers);
}

export default connect(applyState)(SuppliersIndex);
