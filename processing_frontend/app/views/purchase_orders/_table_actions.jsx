import React from 'react';

export default class PurchaseOrdersTableActions extends React.Component {
  render () {
    if (this.props.totalCount == 0) {
      return (<div />);
    }

    return (
      <div className="panel panel-default">
        <div className="panel-body">
          <div className="row">
            <div className="col-md-3">
              <div className="input-group"
                   style={{ maxWidth: '300px' }}>
                <input type="date"
                       name="deliveryDate"
                       className="form-control input-sm"
                       disabled={!this.props.hasSelected}
                       onChange={this.handleDeliveryDateChange.bind(this)} />

                <span className="input-group-btn">
                  <button className="btn btn-warning btn-sm"
                          disabled={!this.props.hasSelected}
                          onClick={this.handleDeliveryDateSubmit.bind(this)}>
                    Change Delivery Date
                  </button>
                </span>
              </div>
            </div>

            <div className="col-md-2">
              <button className="btn btn-danger btn-sm"
                      style={{ width: '100%' }}
                      disabled={!this.props.hasSelected}
                      onClick={this.handleCancelSubmit.bind(this)}>
                Cancel Selected
              </button>
            </div>

            {this.renderCancelPOButton()}

            <div className="col-md-2">
              <button className="btn btn-warning btn-sm"
                      style={{ width: '100%' }}
                      disabled={!this.props.hasSelected}
                      onClick={this.handleUncancelSubmit.bind(this)}>
                Un-cancel Selected
              </button>
            </div>

            <div className="col-md-2" style={{ marginTop: '0.3em' }}>
              {this.renderCountMessage()}
            </div>

            <div className="col-md-1">
              {this.renderExportButton()}
            </div>
          </div>
        </div>
      </div>
    );
  }

  renderCountMessage() {
    if (this.props.currentCount < this.props.totalCount) {
      return (<span>Showing {this.props.currentCount.toLocaleString()} of {this.props.totalCount.toLocaleString()} results</span>);
    }
    return (<span>Showing all of {this.props.totalCount.toLocaleString()} results</span>);
  }

  renderCancelPOButton() {
    if (!this.props.poNumber) {
      return;
    }

    return (
      <div className="col-md-2">
        <button className="btn btn-danger btn-sm"
                style={{ width: '100%' }}
                onClick={this.handleCancelPOSubmit.bind(this)}>
          Cancel PO #{this.props.poNumber}
        </button>
      </div>
    );
  }

  renderExportButton () {
    if (!this.props.exportable) return;

    let additionalParams = {}
    if (this.props.exportable.massive) {
      additionalParams = { disabled: 'disabled',
                           title: 'Result set too big to export' }
    }

    return (
      <a href={this.props.exportable.url}
         className="btn btn-default btn-sm pull-right"
         target="_blank"
         {...additionalParams}>
        export as .csv
      </a>
    );
  }

  handleCancelSubmit (e) {
    e.preventDefault();
    this.props.table.cancelSelected();
  }

  handleCancelPOSubmit (e) {
    e.preventDefault();
    this.props.table.cancelPO();
  }

  handleUncancelSubmit (e) {
    e.preventDefault();
    this.props.table.uncancelSelected();
  }

  handleDeliveryDateChange ({ target }) {
    this.props.table.setDeliveryDate(target.value);
  }

  handleDeliveryDateSubmit (e) {
    e.preventDefault();
    this.props.table.changeDeliveryDateSelected();
  }
}
