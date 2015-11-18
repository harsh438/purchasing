import React from 'react';

export default class OrdersForm extends React.Component {
  componentWillMount() {
    this.state = { creatingOrder: false };
  }

  render() {
    return (
      <form className="form-inline pull-right"
            onChange={this.handleFormChange.bind(this)}
            onSubmit={this.handleFormSubmit.bind(this)}>
        <div className="input-group">
          <input className="form-control"
                 id="order_name"
                 name="name"
                 style={{ width: '300px' }}
                 placeholder="Order name (optional)"
                 value={this.state.name} />

          <span className="input-group-btn">
            <button className="btn btn-success"
                    disabled={this.state.creatingOrder}>
              Create order
            </button>
          </span>
        </div>
      </form>
    );
  }

  handleFormChange({ target }) {
    this.setState({ [target.name]: target.value });
  }

  handleFormSubmit(e) {
    e.preventDefault();
    this.props.onCreateOrder(this.state);
  }
}
