import React from 'react';
import { Link } from 'react-router';
import { connect } from 'react-redux';
import { assign, isEqual } from 'lodash';
import VendorsFilters from './_filters';
import VendorsTable from './_table';
import NumberedPagination from '../pagination/_numbered';
import { loadSuppliers } from '../../actions/filters';
import { loadVendors } from '../../actions/vendors';

class VendorsIndex extends React.Component {
  componentWillMount() {
    this.loadPage();
    this.props.dispatch(loadSuppliers());
  }

  componentWillReceiveProps(nextProps) {
    const nextQuery = nextProps.location.query;

    if (!isEqual(this.props.location.query, nextQuery)) {
      this.loadPage(nextQuery.page, (nextQuery.filters || {}));
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
                <VendorsFilters filters={this.props.location.query.filters}
                                suppliers={this.props.suppliers}
                                onFilterVendors={this.handleFilterVendors.bind(this)} />
              </div>
            </div>
          </div>
        </div>

        <div className="row">
          <div className="col-md-12">
          	<div className="panel panel-default">
        			<div className="panel-body">
                <Link to="/vendors/new"
                      className="btn btn-success">
                  Add New Brand
                </Link>

                <hr style={{ clear: 'both' }} />

                <VendorsTable vendors={this.props.vendors}/>

                <NumberedPagination activePage={this.props.activePage || 1}
                                    index={this}
                                    totalPages={this.props.totalPages} />
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }

  loadPage(page = this.props.location.query.page, filters = this.props.location.query.filters) {
    this.props.dispatch(loadVendors({ filters, page }));
  }

  handleFilterVendors(filters) {
    this.props.history.pushState(null, '/vendors', { filters });
  }
}

function applyState({ filters, vendors }) {
  return assign({}, filters, vendors);
}

export default connect(applyState)(VendorsIndex);
