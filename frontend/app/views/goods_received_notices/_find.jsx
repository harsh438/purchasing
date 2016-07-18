import React from 'react';
import { ButtonToolbar, DropdownButton, MenuItem } from 'react-bootstrap';

export default class GoodsReceivedNoticesFind extends React.Component {
  componentWillMount() {
    this.state = { onLoading: false };
  }

  componentWillReceiveProps(nextProps) {
    if (this.props.noticeWeeks !== nextProps.noticeWeeks ||
        this.props.goodsReceivedNotice !== nextProps.goodsReceivedNotice) {
      this.setState({ onLoading: false });
    }
  }

  render() {
    return (
      <form onChange={this.handleChange.bind(this)}
            onSubmit={(e) => e.preventDefault()}>
        <div style={{ float: 'left', width: '75%' }}>
          <input type="number"
                 className="form-control"
                 placeholder="Search #"
                 onChange={this.handleChange.bind(this, 'search')}
                 value={this.state.search}
                 name="search" />
        </div>

        <div style={{ float: 'right', width: '25%' }}>
          {this.renderSearchButton()}
        </div>
      </form>
    );
  }

  renderSearchButton() {
    if (this.state.onLoading) {
      return (
        <button type="submit"
                className="btn btn-primary"
                disabled>
          Finding...
        </button>
      );
    } else {
      return (
        <ButtonToolbar>
          <DropdownButton bsStyle="primary"
                          id="search-grns"
                          onSelect={this.handleSubmit.bind(this)}
                          pullRight
                          style={{ float: 'right' }}
                          title="Find">
            <MenuItem eventKey="GRN">Find by GRN</MenuItem>
            <MenuItem eventKey="PO">Find by PO</MenuItem>
          </DropdownButton>
        </ButtonToolbar>
      );
    }
  }

  handleChange({ target }) {
    if (!target) { return ; }
    this.setState({ onLoading: false });
    this.setState({ [target.name]: target.value });
  }

  handleSubmit(e, type) {
    e.preventDefault();
    this.setState({ onLoading: true });
    this.props.onSearch({ search: this.state.search, type });
  }
}
