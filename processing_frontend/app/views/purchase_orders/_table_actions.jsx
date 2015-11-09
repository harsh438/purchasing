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

            <div className="col-md-3" style={{ marginTop: '0.5em' }}>
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
