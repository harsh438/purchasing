import React from 'react';
import { connect } from 'react-redux';
import { assign } from 'lodash';
import RefusedDeliveriesLogForm from './_form';
import { createSupplier } from '../../actions/suppliers';
import { Link } from 'react-router';

class RefusedDeliveriesNew extends React.Component {
  componentWillMount() {
    this.state = { createRefusedDeliveries: false };
  }

  componentWillReceiveProps(nextProps) {
    if (this.state.createRefusedDeliveries && nextProps.refusedDeliveries) {
      this.props.history.pushState(null, `/refused-deliveries`);
    }
  }

  render() {
    return (
      <div className="suppliers_new container-fluid"
           style={{ marginTop: '70px' }}>
        <div className="row" style={{ marginBottom: '20px' }}>
          <div className="col-md-6">
            <h1>
              <Link to="/refused-deliveries">refused-deliveries</Link>
              &nbsp;/ Add Refused Deliveries
            </h1>
          </div>
        </div>

        <div className="row">
          <div className="col-md-6">
            <div className="panel panel-default">
              <div className="panel-body">
                <SuppliersForm title="Create Refused Deliveries"
                               submitText="Add Refused Deliveries"
                               onSubmitSupplier={this.handleCreateRefusedDeliveries.bind(this)} />
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }

  handleCreateRefusedDeliveries (refusedDeliveries) {
    this.setState({ createRefusedDeliveries: true });
    this.props.dispatch(createRefusedDeliveries(refusedDeliveries));
  }
}

function applyState({ refusedDeliveries }) {
  return refusedDeliveries;
}

export default connect(applyState)(RefusedDeliveriesNew);
