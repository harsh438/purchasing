import React from 'react';
import { Popover, OverlayTrigger } from 'react-bootstrap';

export default class AbstractEditRow extends React.Component {
  componentWillMount () {
    this.setState({ value: this.props.value });
  }

  render () {
    return (
      <td className={this.props.className}>
        <OverlayTrigger id={`edit-${this.props.fieldKey}-${this.props.orderId}-overlay`}
                        trigger="click"
                        ref="overlayTrigger"
                        rootClose
                        placement="left"
                        overlay={this.popOverlay()}>
          <a style={{ cursor: 'pointer' }}>{this.props.displayValue}</a>
        </OverlayTrigger>
      </td>
    );
  }

  popOverlay() {
    return (
      <Popover id={`edit-${this.props.fieldKey}-${this.props.orderId}-popover`}
               title={`Editing PO #${this.props.orderId}`}>
        <form className="form-horizontal"
              style={{ marginBottom: '0' }}
              onSubmit={this.handleSubmit.bind(this)}>
          <div className="form-group">
            <div className="col-md-12">
              {this.renderInput()}
            </div>
          </div>

          <div className="form-group"
               style={{ marginBottom: '0' }}>
            <div className="col-md-12">
              <button className="btn btn-success"
                      style={{ width: '100%', display: 'block' }}>
                Save
              </button>
            </div>
          </div>
        </form>
      </Popover>
    );
  }

  renderInput() {
    return (<span></span>);
  }

  handleChange (field, { target }) {
    this.setState({ value: target.value });
  }

  handleSubmit (e) {
    e.preventDefault();
    this.props.table.updateField(this.props.orderId, this.props.fieldKey, this.state.value);
    this.refs.overlayTrigger.hide();
  }
}
