import React from 'react';
import ReactDOM from 'react-dom';
import { includes, map } from 'lodash';
import { Popover, OverlayTrigger, Alert, Overlay } from 'react-bootstrap';

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
              <div className="validationTarget" ref="validationTarget">
                {this.renderInput()}
              </div>

              <Overlay id={`edit-${this.props.fieldKey}-${this.props.ident}-validation`}
                       show={this.hasErrors()}
                       target={() => ReactDOM.findDOMNode(this.refs.validationTarget)}>
                 {this.renderErrors()}
              </Overlay>
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
    return (
      <Alert bsStyle="danger"
             id={`${this.props.fieldKey}-${this.props.ident}-alert`}
             style={{ position: 'absolute', zIndex: '10000', marginLeft: '26px', marginTop: '8px' }}>
        {map(this.props.errors, (err, i) => {
          return (
            <span key={i}>{err}</span>
          );
        })}
      </Alert>
    );
  }

  renderInput() {
    return (<span />);
  }

  hasErrors() {
    return (includes(this.props.erroredIds, this.props.ident) &&
            includes(this.props.erroredFields, this.props.fieldKey));
  }

  handleChange(field, { target }) {
    this.setState({ value: target.value });
  }

  handleSubmit(e) {
    e.preventDefault();
    this.props.table.updateField(this.props.ident, this.props.fieldKey, this.state.value);
  }
}
