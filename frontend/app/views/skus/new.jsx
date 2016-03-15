import React from 'react';
import NotificationSystem from 'react-notification-system';
import Select from 'react-select';
import { connect } from 'react-redux';
import { assign } from 'lodash';
import { createSkuByPid } from '../../actions/skus';
import { loadElements } from '../../actions/elements';
import { processNotifications } from '../../utilities/notification';

class SkusNew extends React.Component {
  componentWillMount() {
    this.state = { sku: {}, elements: [] };
    this.props.dispatch(loadElements());
  }

  componentWillReceiveProps(nextProps) {
    const oldSkuId = (this.props.sku || {}).id;
    const newSkuId = (nextProps.sku || {}).id;
    if (oldSkuId !== newSkuId) {
      this.props.history.pushState(null, `/skus/${nextProps.sku.id}/edit`);
    }
    this.setState({ submitting: false });
    processNotifications.call(this, nextProps);
  }

  render() {
    return (
    <div className="skus_new container container-fluid application-root-container">
      <h1>Add New SKU</h1>
      <div className="panel panel-default">
        <div className="panel-body">
          {this.renderForm()}
        </div>
      </div>
    </div>);
  }

  renderForm() {
    return (
      <div>
        <NotificationSystem ref="notificationSystem" />
        <form className="form"
              onChange={this.handleFormChange.bind(this)}
              onSubmit={this.handleFormSubmit.bind(this)}>
          <label htmlFor="product_id">SKU</label>
          <input type="text"
                 className="form-control"
                 id="sku"
                 name="sku"
                 placeholder="SKU to duplicate from"
                 value={this.state.sku.sku}
                 required />
          <br />
          <label htmlFor="product_id">Surfdome Size</label>
          <Select id="elementId"
                  name="elementId"
                  value={this.state.sku.elementId || ''}
                  required
                  options={this.renderElements()}
                  onChange={this.handleElementChange.bind(this)} />
          <br />
          {this.renderSubmitButton()}
        </form>
      </div>
    );
  }

  renderElements() {
    return this.props.elements.map((element) => {
      return { value: element.id, label: element.name };
    });
  }

  renderSubmitButton() {
    if (this.state.submitting) {
      return (<input type="submit" className="btn btn-success" value="Creating New SKU..." disabled />);
    } else {
      return (<input type="submit" className="btn btn-success" value="Create New SKU" />);
    }
  }

  handleElementChange(newValue) {
    this.handleFormChange({
      target: { name: 'elementId', value: newValue },
    });
  }

  handleFormChange({ target }) {
    const sku = assign({}, this.state.sku, { [target.name]: target.value });
    this.setState({ sku });
  }

  handleFormSubmit(e) {
    e.preventDefault();
    this.setState({ submitting: true });
    this.props.dispatch(createSkuByPid(this.state.sku));
  }
}

function applyState({ skus, notification, elements }) {
  return assign({}, skus, notification, elements);
}

export default connect(applyState)(SkusNew);
