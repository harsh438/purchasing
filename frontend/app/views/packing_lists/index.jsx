import React from 'react';
import { connect } from 'react-redux';
import Filters from './_filters';
import Table from './_table';
import { loadPackingLists } from '../../actions/packing_lists';
import { assign, isEqual } from 'lodash';

class PackingListsIndex extends React.Component {
  componentWillMount() {
    this.loadPackingLists();
  }

  componentWillReceiveProps(nextProps) {
    const nextQuery = nextProps.location.query;

    if (!isEqual(this.props.location.query, nextQuery)) {
      this.loadPackingLists(nextQuery || {});
    }
  }

  render() {
    return (
      <div className="suppliers_index container-fluid"
           style={{ marginTop: '70px' }}>
        <div className="row" style={{ marginBottom: '20px' }}>
          <div className="col-md-4">
            <h1>Packing lists</h1>
          </div>
        </div>

        <div className="row">
          <div className="col-md-12">
            <Filters filters={this.props.location.query}
                     onSubmit={this.handleFiltersSubmit.bind(this)} />
            <Table packingLists={this.props.packingLists} />
          </div>
        </div>
      </div>
    );
  }

  loadPackingLists({ dateFrom, dateTo } = this.props.location.query) {
    if (dateFrom && dateTo) {
      this.props.dispatch(loadPackingLists({ dateFrom, dateTo }));
    }
  }

  handleFiltersSubmit({ dateFrom, dateTo }) {
    this.props.history.pushState(null, '/warehouse/packing-lists', { dateFrom, dateTo });
  }
}

function applyState({ packingLists }) {
  return assign({}, packingLists);
}

export default connect(applyState)(PackingListsIndex);
