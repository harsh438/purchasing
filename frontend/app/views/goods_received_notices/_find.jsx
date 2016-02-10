import React from 'react';

export default class GoodsReceivedNoticesFind extends React.Component {
  componentWillMount() {
    this.state = { onLoading: false };
  }

  componentWillReceiveProps(nextProps) {
    if (nextProps.goodsReceivedNotice) {
      this.setState({ search: nextProps.goodsReceivedNotice.id, onLoading: false });
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
          {this.renderSearchButton()}
        </span>
      </div>
    </form>
    );
  }

  renderSearchButton() {
    if (this.state.onLoading) {
      return <input disabled type="submit" className="btn btn-primary" value="Finding..." />;
    } else {
      return <input type="submit" className="btn btn-primary" value="Find" />;
    }
  }

  handleChange({ target }) {
    if (!target) { return ; }
    this.setState({ [target.name]: target.value });
  }

  handleSubmit(e) {
    e.preventDefault();
    this.setState({ onLoading: true });
    this.props.onSearch(parseInt(this.state.search, 10));
  }
}
