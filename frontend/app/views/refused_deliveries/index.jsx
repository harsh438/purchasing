import React from 'react';
import { connect } from 'react-redux';
import { Link } from 'react-router';
import Filters from './_filters';
import Table from './_table';
import { loadRefusedDeliveries } from '../../actions/refused_deliveries';
import { assign, intersection, isEqual, map} from 'lodash';
import { loadVendors } from '../../actions/filters';

class RefusedDeliveriesIndex extends React.Component {
  componentWillMount() {
    this.props.dispatch(loadVendors());
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
              Add refused-deliveries
            </Link>
          </div>
        </div>

        <div className="row">
          <div className="col-md-12">
            <Filters filters={this.props.location.query}
                     onSubmit={this.handleFiltersSubmit.bind(this)} />
                   <Table refusedDeliveriesLogs={this.props.refusedDeliveriesLogs} />
          </div>
        </div>
      </div>

      <Filters brands={this.props.brands}/>
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

function applyState({ refusedDeliveriesLogs }) {
  return assign({}, refusedDeliveriesLogs);
}

export default connect(applyState)(RefusedDeliveriesIndex);
