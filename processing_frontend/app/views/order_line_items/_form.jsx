import React from 'react';
import OrderLineItemsSpreadsheet from './_spreadsheet';
import { getScript } from '../../utilities/get_script';
import { Alert, Nav, NavItem } from 'react-bootstrap';
import { WeekSelect } from './_week_select';
import { map } from 'lodash';

export default class OrderLineItemsForm extends React.Component {
  componentWillMount() {
    this.resetState();
  }

  componentWillReceiveProps(nextProps) {
    if (this.props != nextProps && !this.hasErrors(nextProps)) {
      this.resetState();
    }
  }

  render() {
    return (
      <div className="order_line_item_form">
        <Nav bsStyle="tabs"
             activeKey={this.state.tab}
             onSelect={this.handleTabChange.bind(this)}>
          <NavItem eventKey={"multi"} title="Copy and paste from Excel">Multi</NavItem>
          <NavItem eventKey={"single"} title="Add one row at a time">Single</NavItem>
        </Nav>

        <div style={{ paddingTop: '1em' }}>
          {this.renderErrors()}
          {this.renderMulti()}
          {this.renderSingle()}
        </div>
      </div>
    )
  }

  renderMulti() {
    if (this.state.tab !== 'multi') return;

    return(
      <form className="form" onSubmit={this.handleMultiSubmit.bind(this)}>
        <OrderLineItemsSpreadsheet onChange={this.handleSpreadsheetChange.bind(this)} />

        <div className="form-group" style={{ marginTop: '1.7em' }}>
          <button className="btn btn-success">
            Create
          </button>
        </div>
      </form>
    );
  }

  renderSingle() {
    if (this.state.tab !== 'single') return;

    return (
      <form className="form" onSubmit={this.handleSingleSubmit.bind(this)}>
        <div className="row">
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
        </div>
      </form>
    );
  }

  renderErrors() {
    if (this.hasErrors(this.props)) {
      return (
        <Alert bsStyle="danger">
          <ul>
            {map(this.props.errors, (err, i) => {
              return (
                <li key={i}><strong>{err}</strong></li>
              );
            })}
          </ul>
        </Alert>
      );
    }
  }

  handleSpreadsheetChange(data) {
    this.setState({ spreadSheetData: data });
  }

  multiData() {
    return map(this.state.spreadSheetData, (line) => {
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
                    discount: '0.00',
                    tab: 'multi' });
  }

  hasErrors(props) {
    return (props.errors != null && props.erroredFields == null);
  }

  handleTabChange(selectedKey) {
    this.setState({ tab: selectedKey });
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
