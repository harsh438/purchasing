import React from 'react';
import { Link } from 'react-router';
import { connect } from 'react-redux';
import { assign, isEqual } from 'lodash';
import { loadSkus } from '../../actions/skus';
import { loadVendors } from '../../actions/filters';
import NumberedPagination from '../pagination/_numbered';
import SkusTable from './_table';
import SkusFilters from './_filters';

class SkusIndex extends React.Component {
  componentWillMount() {
    this.loadPage();
    this.props.dispatch(loadVendors());
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
        </div>

        <div className="row">
          <div className="col-md-12">
            <div className="panel panel-default">
              <div className="panel-body">
                <SkusFilters filters={this.props.location.query.filters}
                             brands={this.props.brands}
                             onFilterSkus={this.handleFilterSkus.bind(this)} />

              </div>
            </div>

            <SkusTable skus={this.props.skus}/>

            <NumberedPagination activePage={this.props.activePage || 1}
                                index={this}
                                totalPages={this.props.totalPages} />
          </div>
        </div>
      </div>
    );
  }

  loadPage(page = this.props.location.query.page, filters = this.props.location.query.filters) {
    this.props.dispatch(loadSkus({ filters, page }));
  }

  handleFilterSkus(filters) {
    this.props.history.pushState(null, '/skus', { filters });
  }
}

function applyState({ filters, skus }) {
  return assign({}, filters, skus);
}

export default connect(applyState)(SkusIndex);
