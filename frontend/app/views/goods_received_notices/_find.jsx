import React from 'react';

export default class GoodsReceivedNoticesFind extends React.Component {
  componentWillMount() {
    this.state = {};
  }

  componentWillReceiveProps(nextProps) {
    if (nextProps.goodsReceivedNotice) {
      this.setState({ search: nextProps.goodsReceivedNotice.id });
    }
  }

  render() {
    return (
      <form onChange={this.handleChange.bind(this)}
            onSubmit={this.handleSubmit.bind(this)}>
        <div className="input-group">
        <input type="number"
               className="form-control"
               placeholder="GRN #"
               onChange={this.handleChange.bind(this, 'search')}
               value={this.state.search}
               name="search" />
        <span className="input-group-btn">
          <input type="submit" className="btn btn-primary"
                 value="Find" />
        </span>
      </div>
    </form>
    );
  }

  handleChange({ target }) {
    if (!target) { return ; }
    this.setState({ [target.name]: target.value });
  }

  handleSubmit(e) {
    e.preventDefault();
    this.props.onSearch(parseInt(this.state.search, 10));
  }
}
