import React from 'react';
import { connect } from 'react-redux';
import { assign, isEqual, map } from 'lodash';
import { loadTerms } from '../../actions/supplier_terms';
import NumberedPagination from '../pagination/_numbered';
import SuppliersTable from './_table';

class SuppliersTermsIndex extends React.Component {
  componentWillMount() {
    this.loadPage();
    this.props.dispatch(loadTerms());
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
    return (<div style={{ 'marginTop': '70px'}}>
      <div className="col-xs-12">
          <div className="panel panel-default">
              <div className="panel-heading" style={{ overflow: 'hidden'}}>
                <h3 className="panel-title pull-left">Terms</h3>
              </div>
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
}


function applyState({ filters, terms }) {
  return assign({}, filters, terms);
}

export default connect(applyState)(SuppliersTermsIndex);
