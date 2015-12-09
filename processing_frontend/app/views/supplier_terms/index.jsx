import React from 'react';
import { connect } from 'react-redux';
import { assign, isEqual, map } from 'lodash';
import { loadTerms } from '../../actions/supplier_terms';
import { loadSuppliers, loadVendors, loadSeasons, loadSupplierTermsList } from '../../actions/filters';
import NumberedPagination from '../pagination/_numbered';
import SuppliersTable from './_table';
import SupplierTermsFilters from './_filters';
import Qs from 'qs';

class SuppliersTermsIndex extends React.Component {
  componentWillMount() {
    this.loadPage();
    this.props.dispatch(loadSuppliers());
    this.props.dispatch(loadVendors());
    this.props.dispatch(loadSeasons());
    this.props.dispatch(loadSupplierTermsList());
  }

  componentWillReceiveProps(nextProps) {
    const nextQuery = nextProps.location.query;

    if (!isEqual(this.props.location.query, nextQuery)) {
      this.loadPage(nextQuery.page, (nextQuery.filters || {}));
    }
  }

  loadPage(page = this.props.location.query.page, filters = this.props.location.query.filters) {
    this.props.dispatch(loadTerms({ filters, page }));
  }

  render() {
    return (
      <div className="container-fluid" style={{ marginTop: '70px' }}>
        <div className="panel panel-default">
          <div className="panel-body">
            <SupplierTermsFilters supplierTermsList={this.props.supplierTermsList}
                                  suppliers={this.props.suppliers}
                                  brands={this.props.brands}
                                  seasons={this.props.seasons}
                                  filters={this.props.location.query.filters}
                                  onFilter={this.handleFilters.bind(this)}/>
          </div>
        </div>

        <div className="panel panel-default">
          <div className="panel-body">
            <div className="text-right">
              <a href={this.exportUrl()} className="btn btn-default">
                <span className="glyphicon glyphicon-cloud-download" aria-hidden="true"></span>&nbsp;
                Export as CSV
              </a>
            </div>

            <hr />

            <SuppliersTable terms={this.props.terms}
                            termsSelected={this.props.location.query.filters.terms}
                            hasSupplierName />

            <NumberedPagination activePage={this.props.activePage || 1}
                                index={this}
                                totalPages={this.props.totalPages} />
          </div>
        </div>
      </div>
    );
  }

  handleFilters(filters) {
    this.props.history.pushState(null, '/terms', { filters });
  }

  exportUrl() {
    const queryString = Qs.stringify({ filters: this.props.location.query.filters });
    return `/api/supplier_terms.csv?${queryString}`;
  }
}

function applyState({ filters, terms, supplierTermsList }) {
  return assign({}, filters, terms, supplierTermsList);
}

export default connect(applyState)(SuppliersTermsIndex);
