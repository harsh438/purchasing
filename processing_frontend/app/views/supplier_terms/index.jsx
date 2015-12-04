import React from 'react';
import { connect } from 'react-redux';
import { assign, isEqual, map } from 'lodash';
import { loadTerms } from '../../actions/supplier_terms';
import { loadSuppliers, loadBrands, loadSeasons } from '../../actions/filters';
import NumberedPagination from '../pagination/_numbered';
import SuppliersTable from './_table';
import SupplierTermsFilters from './_filters';

class SuppliersTermsIndex extends React.Component {
  componentWillMount() {
    this.state = {};
    this.loadPage();
    this.props.dispatch(loadSuppliers());
    this.props.dispatch(loadBrands());
    this.props.dispatch(loadSeasons());
  }

  componentWillReceiveProps(nextProps) {
    const nextQuery = nextProps.location.query;

    if (!isEqual(this.props.location.query, nextQuery)) {
      this.loadPage(nextQuery.page, (nextQuery.filters || {}));
    }
    let filters = this.props.location.query.filters || {};
    if (typeof filters['default'] === 'undefined') {
      filters['default'] = true;
    }
    this.setState({filters: filters});
  }

  loadPage(page = this.props.location.query.page, filters = this.props.location.query.filters) {
    this.props.dispatch(loadTerms({ filters, page }));
  }

  render() {
    return (<div style={{ 'marginTop': '70px'}}>
      <div className="col-xs-12">
          <div className="panel panel-default">
            <div className="panel-body">
              <SupplierTermsFilters
                  suppliers={this.props.suppliers}
                  brands={this.props.brands}
                  seasons={this.props.seasons}
                  filters={this.state.filters}
                  onFilter={this.handleFilters.bind(this)}/>
            </div>
          </div>

          <div className="panel panel-default">
              <div className="panel-body">
                <SuppliersTable terms={this.props.terms} />
              </div>
                <NumberedPagination activePage={this.props.activePage || 1}
                      index={this}
                      totalPages={this.props.totalPages} />
          </div>
      </div>
    </div>);
  }

  handleFilters(filters) {
    this.props.history.pushState(null, '/terms', { filters });
  }
}


function applyState({ filters, terms}) {
  return assign({}, filters, terms);
}

export default connect(applyState)(SuppliersTermsIndex);
