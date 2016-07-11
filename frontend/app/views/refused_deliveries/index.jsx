import React from 'react';
import { connect } from 'react-redux';
import { Link } from 'react-router';
import Filters from './_filters';
import Table from './_table';
import { loadRefusedDeliveries } from '../../actions/refused_deliveries';
import { assign, isEqual } from 'lodash';


class RefusedDeliveriesIndex extends React.Component {
  componentWillMount() {
    this.loadRefusedDeliveries();
  }

  componentWillReceiveProps(nextProps) {
    const nextQuery = nextProps.location.query;

    if (!isEqual(this.props.location.query, nextQuery)) {
      this.loadRefusedDeliveries(nextQuery || {});
    }
  }

  render() {
    return (
      <div className="suppliers_index container-fluid"
           style={{ marginTop: '70px' }}>
        <div className="row" style={{ marginBottom: '20px' }}>
          <div className="col-md-4">
            <h1>Refused Delivery Log</h1>
          </div>

          <div className="col-md-2 col-md-offset-6 text-right">
            <Link to="/warehouse/refused-deliveries/new"
                  className="btn btn-success">
              Add Refused Delivery
            </Link>
          </div>
        </div>

        <div className="row">
          <div className="col-md-12">
            <Filters brands={this.props.brands}
                     filters={this.props.location.query}
                     onSubmit={this.handleFiltersSubmit.bind(this)} />
            <Table refusedDeliveries={this.props.refusedDeliveries} />
          </div>
        </div>
      </div>
    );
  }

  loadRefusedDeliveries({ dateFrom, dateTo } = this.props.location.query) {
    if (dateFrom && dateTo) {
      this.props.dispatch(loadRefusedDeliveries({ dateFrom, dateTo }));
    }
  }

  handleFiltersSubmit({ dateFrom, dateTo }) {
    this.props.history.pushState(null, '/warehouse/refused-deliveries', { dateFrom, dateTo });
  }
}

function applyState({ refusedDeliveries }) {
  return assign({}, refusedDeliveries);
}

export default connect(applyState)(RefusedDeliveriesIndex);
