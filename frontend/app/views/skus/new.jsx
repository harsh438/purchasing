import React from 'react';
import NotificationSystem from 'react-notification-system';
import { connect } from 'react-redux';
import { assign } from 'lodash';
import { createSkuByPid } from '../../actions/skus';
import { processNotifications } from '../../utilities/notification';

class SkusNew extends React.Component {
  componentWillMount() {
    this.state = { sku: {} };
  }

  componentWillReceiveProps(nextProps) {
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
          <label htmlFor="product_id">PID</label>
          <input type="number"
                 className="form-control"
                 id="productId"
                 name="productId"
                 placeholder="PID associated with the SKU"
                 value={this.state.sku.productId} />
          <br />
          {this.renderSubmitButton()}
        </form>
      </div>
    );
  }

  renderSubmitButton() {
    if (this.state.submitting) {
      return (<input type="submit" className="btn btn-success" value="Creating New SKU..." disabled />);
    } else {
      return (<input type="submit" className="btn btn-success" value="Create New SKU" />);
    }
  }

  handleFormChange ({ target }) {
    const sku = assign({}, this.state.sku, { [target.name]: target.value });
    this.setState({ sku });
  }

  handleFormSubmit(e) {
    e.preventDefault();
    this.setState({ submitting: true });
    this.props.dispatch(createSkuByPid(this.state.sku));
  }
}

function applyState({ skus, notification }) {
  return assign({}, skus, notification);;
}

export default connect(applyState)(SkusNew);
