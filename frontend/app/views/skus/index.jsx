import React from 'react';
import { Link } from 'react-router';
import { connect } from 'react-redux';
import { assign, isEqual, isEmpty } from 'lodash';
import { loadSkus } from '../../actions/skus';
import { loadSeasons, loadVendors } from '../../actions/filters';
import NumberedPagination from '../pagination/_numbered';
import SkusTable from './_table';
import SkusFilters from './_filters';
import { renderCsvExportLink } from '../../utilities/dom';
import { snakeizeKeys } from '../../utilities/inspection';
import Qs from 'qs';

class SkusIndex extends React.Component {
  componentWillMount() {
    this.loadPage();
    this.props.dispatch(loadVendors());
    this.props.dispatch(loadSeasons());
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
            <h1>SKUs</h1>
          </div>
          {this.renderAddNewSku()}
        </div>

        <div className="row">
          <div className="col-md-12">
            <div className="panel panel-default">
              <div className="panel-body">
                <SkusFilters filters={this.props.location.query.filters}
                             brands={this.props.brands}
                             seasons={this.props.seasons}
                             onFilterSkus={this.handleFilterSkus.bind(this)} />

              </div>
            </div>

            <div className="text-right">
              {this.renderCSVButton()}
            </div>

            <hr />

            <SkusTable skus={this.props.skus}/>

            <NumberedPagination activePage={this.props.activePage || 1}
                                index={this}
                                totalPages={this.props.totalPages} />
          </div>
        </div>
      </div>
    );
  }

  renderAddNewSku() {
    if (this.props.advanced) {
      return (
        <Link className="pull-right btn btn-success"
              to={`/skus/new`}>
          Add new SKU
        </Link>);
    }
  }

  renderCSVButton() {
    const disabled = isEmpty(this.props.location.query.filters);
    const text =  'Export to Excel';
    return renderCsvExportLink(this.supplierSkuSummaryExportUrl(), { disabled, text });
  }

  supplierSkuSummaryExportUrl() {
    const filters = snakeizeKeys(this.props.location.query.filters);
    const queryString = Qs.stringify({ filters },
                                     { arrayFormat: 'brackets' });
    return `/api/skus/supplier_summary.xlsx?${queryString}`;
  }

  loadPage(page = this.props.location.query.page, filters = this.props.location.query.filters) {
    this.props.dispatch(loadSkus({ filters, page }));
  }

  handleFilterSkus(filters) {
    this.props.history.pushState(null, '/skus', { filters });
  }
}

function applyState({ advanced, filters, skus }) {
  return assign({ advanced }, filters, skus);
}

export default connect(applyState)(SkusIndex);
