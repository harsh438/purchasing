import React from 'react';
import { includes, map } from 'lodash';
import { Popover, OverlayTrigger, Alert } from 'react-bootstrap';

export default class AbstractEditRow extends React.Component {
  componentWillMount() {
    this.setState({ value: this.props.value });
  }

  componentWillReceiveProps(nextProps) {
    if (nextProps.errors == null) {
      this.refs.overlayTrigger.hide();
    }
  }

  render() {
    return (
      <OverlayTrigger id={`edit-${this.props.fieldKey}-${this.props.ident}-overlay`}
                      trigger="click"
                      ref="overlayTrigger"
                      rootClose
                      placement="left"
                      overlay={this.popOverlay()}>
        <a style={{ cursor: 'pointer' }}>{this.props.displayValue}</a>
      </OverlayTrigger>
    );
  }

  popOverlay() {
    return (
      <Popover id={`edit-${this.props.fieldKey}-${this.props.ident}-popover`}
               title={this.props.title}>
        <form className="form-horizontal"
              style={{ marginBottom: '0' }}
              onSubmit={this.handleSubmit.bind(this)}>
          <div className="form-group">
            <div className="col-md-12">
              {this.renderErrors()}
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

  renderErrors() {
    if (!includes(this.props.erroredFields, this.props.fieldKey)) {
      return (<span />);
    }

    return (
      <Alert bsStyle="danger">
        <ul>
          {map(this.props.errors, (err, i) => {
            return (
              <li key={i}>{err}</li>
            );
          })}
        </ul>
      </Alert>
    );
  }

  renderInput() {
    return (<span />);
  }

  handleChange(field, { target }) {
    this.setState({ value: target.value });
  }

  handleSubmit(e) {
    e.preventDefault();
    this.props.table.updateField(this.props.ident, this.props.fieldKey, this.state.value);
  }
}
