import React from 'react';
import { connect } from 'react-redux';

class SkusNew extends React.Component {
  componentWillMount() {
    this.state = {};
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
      <form className="form">
        <label htmlFor="product_id">PID</label>
        <input className="form-control"
               id="product_id"
               name="invoicer_name"
               placeholder="PID associated with the SKU"
               value={this.state.product_id} />
      </form>
    );
  }
}

function applyState({ suppliers }) {
  return suppliers;
}

export default connect(applyState)(SkusNew);
