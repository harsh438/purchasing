import React from 'react';
import { connect } from 'react-redux';
import { assign } from 'lodash';
import RefusedDeliveriesForm from './_form';
import { createRefusedDelivery } from '../../actions/refused_deliveries';
import { Link } from 'react-router';
import { loadVendors } from '../../actions/filters';

class RefusedDeliveriesNew extends React.Component {
  componentWillMount() {
    this.state = { createRefusedDelivery: false };
    this.props.dispatch(loadVendors());
  }

  componentWillReceiveProps(nextProps) {
    if (this.state.createRefusedDelivery && nextProps.refusedDelivery) {
      this.props.history.pushState(null, `/warehouse/refused-deliveries`);
    }
  }

  render() {
    return (
      <div className="suppliers_new container-fluid"
           style={{ marginTop: '70px' }}>
        <div className="row" style={{ marginBottom: '20px' }}>
          <div className="col-md-6">
            <h1>
              <Link to="/warehouse/refused-deliveries">Refused Deliveries</Link>
              &nbsp;/ Add Refused Delivery
            </h1>
          </div>
        </div>

        <div className="row">
          <div className="col-md-6">
            <div className="panel panel-default">
              <div className="panel-body">
                <RefusedDeliveriesForm title="Create Refused Delivery"
                                       submitText="Add Refused Delivery"
                                       brands={this.props.brands}
                                       onSubmitRefusedDelivery={this.handleCreateRefusedDelivery.bind(this)} />
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }

  handleCreateRefusedDelivery (refusedDelivery) {
    this.setState({ createRefusedDelivery: true });
    this.props.dispatch(createRefusedDelivery(refusedDelivery));
  }
}

function applyState({ filters, refusedDeliveries }) {
  return assign({}, filters, refusedDeliveries);
}

export default connect(applyState)(RefusedDeliveriesNew);
