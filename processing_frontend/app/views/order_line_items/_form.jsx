import React from 'react';
import { getScript } from '../../utilities/get_script';
import { Alert, Nav, NavItem } from 'react-bootstrap';
import { WeekSelect } from './_week_select';
import { map } from 'lodash';

export default class OrderLineItemsForm extends React.Component {
  componentWillMount() {
    this.resetState();
    getScript('/assets/handsontable.full.min.js', this.createHandsOnTable.bind(this));
  }

  componentWillReceiveProps(nextProps) {
    if (this.props != nextProps && !this.hasErrors(nextProps)) {
      this.resetState();
    }
  }

  render() {
    return (
      <div>
        {this.renderMulti()}
        {this.renderSingle()}
      </div>
    )
  }

  renderMulti() {
    return(
      <div className="row">
        <div className="col-md-12">
          <div className="panel panel-default">
            <div className="panel-heading">Add line items from CSV</div>
            <div className="panel-body">
              <div className="row">
                <form className="form" onSubmit={this.handleMultiSubmit.bind(this)}>
                  <div className="col-md-10">
                    <div id="line-item-table"></div>
                  </div>

                  <div className="form-group col-md-2" style={{ marginTop: '1.7em' }}>
                    <button className="btn btn-success">
                      Create
                    </button>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }

  renderSingle() {
    return (
      <div className="row">
        <div className="col-md-12">
          <div className="panel panel-default">
            <div className="panel-heading">
              <h3 className="panel-title">Add Product to Order</h3>
            </div>

            <div className="panel-body">
              {this.renderErrors()}

              <form className="form" onSubmit={this.handleSingleSubmit.bind(this)}>
                <div className="form-group col-md-2">
                  <label htmlFor="internalSku">Internal SKU</label>
                  <input type="text"
                         name="internalSku"
                         onChange={this.handleChange.bind(this, 'internalSku')}
                         className="form-control"
                         required="required"
                         value={this.state.internalSku} />
                </div>

                <div className="form-group col-md-2">
                  <label htmlFor="quantity">Quantity</label>
                  <input type="number"
                         name="quantity"
                         onChange={this.handleChange.bind(this, 'quantity')}
                         className="form-control"
                         required="required"
                         value={this.state.quantity} />
                </div>

                <div className="form-group col-md-2">
                  <label htmlFor="discount">Discount %</label>
                  <input type="number"
                         step="0.01"
                         name="discount"
                         onChange={this.handleChange.bind(this, 'discount')}
                         className="form-control"
                         required="required"
                         value={this.state.discount} />
                </div>

                <WeekSelect table={this} ref="dropDate" />

                <div className="form-group col-md-2" style={{ marginTop: '1.7em' }}>
                  <button className="btn btn-success">
                    Create
                  </button>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    );
  }

  renderErrors() {
    if (!this.hasErrors(this.props)) {
      return (<span />);
    }

    return (
      <Alert bsStyle="danger">
        <ul>
          {map(this.props.errors.errors, (err, i) => {
            return (
              <li key={i}><strong>{err}</strong></li>
            );
          })}
        </ul>
      </Alert>
    );
  }

  createHandsOnTable() {
    this.handsOnTable = new window.Handsontable(document.getElementById('line-item-table'),
      { data: [['', '', '', '']],
        colHeaders: ['Internal SKU', 'Quantity', 'Discount %', 'Drop Date'],
        columns: [
          { data: 'internalSku' },
          { data: 'quantity', type: 'numeric' },
          { data: 'discount', type: 'numeric' },
          { data: 'dtopDate', type: 'date', dateFormat: 'YYYY-MM-DD', correctFormat: true }
        ],
        rowHeaders: true,
        columnSorting: true,
        contextMenu: true })
  }

  multiData() {
    return map(this.handsOnTable.getData(), (line) => {
      return { internalSku: line[0],
               quantity: parseInt(line[1], 10),
               discount: parseFloat(line[2], 10),
               dropDate: line[3] };
    });
  }

  singleData() {
    return [{ internalSku: this.state.internalSku,
              quantity: this.state.quantity,
              cost: this.state.cost,
              discount: this.state.discount,
              dropDate: this.refs.dropDate.state.dropDate }];
  }

  resetState() {
    this.setState({ internalSku: '',
                    quantity: 0,
                    productCost: '0.00',
                    discount: '0.00' });
  }

  hasErrors(props) {
    return ('errors' in props && props.errors != null);
  }

  handleMultiSubmit(e) {
    e.preventDefault();
    this.props.onAddLineItems(this.multiData());
  }

  handleSingleSubmit(e) {
    e.preventDefault();
    this.props.onAddLineItems(this.singleData());
  }

  handleChange(field, { target }) {
    this.setState({ [field]: target.value });
  }
}
