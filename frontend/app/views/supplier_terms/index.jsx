import React from 'react';
import { connect } from 'react-redux';
import { assign, isEqual, map } from 'lodash';
import { loadSupplierTerms } from '../../actions/supplier_terms';
import { loadSuppliers,
         loadVendors,
         loadSeasons,
         loadSupplierTermsList } from '../../actions/filters';
import NumberedPagination from '../pagination/_numbered';
import SuppliersTable from './_table';
import SupplierTermsFilters from './_filters';
import Qs from 'qs';
import { renderCsvExportLink } from '../../utilities/dom';

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

  render() {
    return (
      <div className="container-fluid" style={{ marginTop: '70px' }}>
        <div className="row" style={{ marginBottom: '20px' }}>
          <div className="col-md-12">
            <h1>Supplier Terms</h1>
          </div>
        </div>

        <div className="row">
          <div className="col-md-12">
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

            <div className="text-right">
              {renderCsvExportLink(this.exportUrl())}
            </div>

            <hr />

            <SuppliersTable terms={this.props.supplierTerms}
                            termsSelected={this.termsSelected()}
                            hasSupplierName />

            <NumberedPagination activePage={this.props.activePage || 1}
                                index={this}
                                totalPages={this.props.totalPages} />
          </div>
        </div>
      </div>
    );
  }

  loadPage(page = this.props.location.query.page, filters = this.props.location.query.filters) {
    this.props.dispatch(loadSupplierTerms({ filters, page }));
  }

  handleFilters(filters) {
    this.props.history.pushState(null, '/terms', { filters });
  }

  exportUrl() {
    const queryString = Qs.stringify({ filters: this.props.location.query.filters },
                                     { arrayFormat: 'brackets' });
    return `/api/supplier_terms.csv?${queryString}`;
  }

  termsSelected() {
    const filters = this.props.location.query.filters;

    if (filters) {
      return filters.terms;
    } else {
      return [];
    }
  }
}

function applyState({ filters, supplierTerms, supplierTermsList }) {
  return assign({}, filters, supplierTerms, supplierTermsList);
}

export default connect(applyState)(SuppliersTermsIndex);
