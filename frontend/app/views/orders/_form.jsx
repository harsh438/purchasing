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
        <div className="form-group">
          <input className="form-control"
                 id="order_name"
                 name="name"
                 style={{ width: '300px' }}
                 placeholder="Order name (optional)"
                 value={this.state.name}/>
        </div>
        <div className="form-group">
          <select className="form-control"
                  name="season"
                  value={this.state.season}
                  required>
            <option value="">Season</option>
            {this.renderSeasons()}
          </select>
        </div>
        <div className="input-group">
          <span className="input-group-btn">
            <button className="btn btn-success"
                    disabled={this.state.creatingOrder}>
              Create reorder
            </button>
          </span>
        </div>
      </form>
    );
  }

  renderSeasons() {
    return this.props.seasons.map((season) => {
      return <option key={season.name} value={season.name}>{season.name}</option>;
    });
  }

  handleFormChange({ target }) {
    this.setState({ [target.name]: target.value });
  }

  handleFormSubmit(e) {
    e.preventDefault();
    this.setState({ creatingOrder: true });
    this.props.onCreateOrder(this.state);
  }
}
