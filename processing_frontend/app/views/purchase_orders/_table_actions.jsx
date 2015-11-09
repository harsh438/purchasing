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
            <div className="col-md-2">
              {this.renderCountMessage()}
            </div>

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

            <div className="col-md-4">
              <div className="btn-group btn-group-sm">
                <button className="btn btn-danger btn-sm"
                        disabled={!this.props.hasSelected}
                        onClick={this.handleCancelSubmit.bind(this)}>
                  Cancel Selected
                </button>

                <button className="btn btn-warning btn-sm"
                        disabled={!this.props.hasSelected}
                        onClick={this.handleUncancelSubmit.bind(this)}>
                  Uncancel Selected
                </button>
              </div>
            </div>

            <div className="col-md-2">
              {this.renderCancelPOButton()}
            </div>

            <div className="col-md-2">
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
    const { currentCount, totalCount } = this.props;

    if (currentCount < totalCount) {
      return (
        <div style={{ lineHeight: '2em' }}>
          Showing {currentCount.toLocaleString()} of {totalCount.toLocaleString()} results
        </div>
      );
    } else {
      return (
        <div style={{ lineHeight: '2em' }}>
          Showing all of {totalCount.toLocaleString()} results
        </div>
      );
    }
  }

  renderCancelPOButton() {
    if (!this.props.poNumber) {
      return;
    }

    return (
      <button className="btn btn-danger btn-sm"
              style={{ width: '100%' }}
              onClick={this.handleCancelPOSubmit.bind(this)}>
        Cancel PO #{this.props.poNumber}
      </button>
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
