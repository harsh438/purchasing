import React from 'react';
import { Popover, OverlayTrigger } from 'react-bootstrap';

export default class OrderedEdit extends React.Component {
  componentWillMount () {
    this.setState({ cost: this.props.orderedCost, qty: this.props.orderedQuantity })
  }

  render () {
    return (
      <td>
        <OverlayTrigger id={`edit-${this.props.orderId}`}
                        trigger="click"
                        rootClose
                        placement="left"
                        overlay={this.popOverlay()}>
          <a style={{ cursor: 'pointer' }}>{this.props.orderedQuantity}</a>
        </OverlayTrigger>
      </td>
    );
  }

  popOverlay() {
    return (
      <Popover title={`Editing PO #${this.props.orderId}`}>
        <form className="form-horizontal"
              style={{ marginBottom: '0' }}
              onSubmit={this.handleSubmit.bind(this)}>
          <div className="form-group">
            <label for="qty" className="col-sm-2 control-label">Qty: </label>
            <div className="col-md-10">
              <input type="number"
                     className="form-control"
                     onChange={this.handleChange.bind(this, 'qty')}
                     value={this.state.qty} name="qty" />
            </div>
          </div>
          <div className="form-group">
            <label for="cost" className="col-sm-2 control-label">Cost: </label>
            <div className="col-md-10">
              <div className="input-group">
                <div className="input-group-addon">£</div>
                  <input type="text"
                         className="form-control"
                         onChange={this.handleChange.bind(this, 'cost')}
                         value={this.state.cost} name="cost" />
                </div>
              </div>
          </div>
          <div className="form-group"
               style={{ marginBottom: '0' }}>
            <div className="col-md-12">
              <button className="btn btn-success"
                      style={{ width: '100%', display: 'block' }}>Submit</button>
            </div>
          </div>
        </form>
      </Popover>
    );
  }

  handleChange (field, { target }) {
    this.setState({ [field]: target.value });
  }

  handleSubmit (e) {
    e.preventDefault();
    this.props.table.updateQtyCost(this.props.id, this.state.qty, this.state.cost)
  }
}
