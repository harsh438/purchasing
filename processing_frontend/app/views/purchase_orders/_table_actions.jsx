import React from 'react';

export default class PurchaseOrdersTableActions extends React.Component {
  render () {
    return (
      <div className="panel panel-default">
        <div className="panel-body">
          <div className="row">
            <div className="col-md-4">
              <div className="input-group"
                   style={{ maxWidth: '300px' }}>
                <input type="date"
                       name="deliveryDate"
                       className="form-control"
                       onChange={this.handleDeliveryDateChange.bind(this)} />

                <span className="input-group-btn">
                  <button className="btn btn-warning"
                          onClick={this.handleDeliveryDateSubmit.bind(this)}>
                    Change Delivery Date
                  </button>
                </span>
              </div>
            </div>

            <div className="col-md-2">
              <button className="btn btn-danger"
                      style={{ width: '100%' }}
                      onClick={this.handleCancelSubmit.bind(this)}>
                Cancel Selected
              </button>
            </div>

            <div className="col-md-2">
              <button className="btn btn-warning"
                      style={{ width: '100%' }}
                      onClick={this.handleUncancelSubmit.bind(this)}>
                Un-cancel Selected
              </button>
            </div>

            <div className="col-md-4">
            </div>
          </div>
        </div>
      </div>
    );
  }

  handleCancelSubmit (e) {
    e.preventDefault();
    this.props.index.cancelSelected();
  }

  handleUncancelSubmit (e) {
    e.preventDefault();
    this.props.index.uncancelSelected();
  }

  handleDeliveryDateChange ({ target }) {
    this.props.index.setDeliveryDate(target.value);
  }

  handleDeliveryDateSubmit (e) {
    e.preventDefault();
    this.props.index.changeDeliveryDateSelected();
  }
}
