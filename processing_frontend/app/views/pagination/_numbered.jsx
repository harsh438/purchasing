import React from 'react'
import { Pagination } from 'react-bootstrap'

export default class NumberedPagination extends React.Component {
  componentWillMount() {
    this.setState({ activePage: this.props.activePage || 1 });
  }

  handleSelect(event, selectedEvent) {
    event.preventDefault();
    this.setState({
      activePage: selectedEvent.eventKey
    });

    this.props.loadPage(selectedEvent.eventKey)
  }

  render() {
    return (
      <div style={{ marginLeft: '20px' }}>
        <Pagination
          first
          last
          bsSize="medium"
          items={this.props.pages}
          activePage={this.state.activePage}
          onSelect={this.handleSelect.bind(this)} />
        <br />
      </div>
    );
  }
}
