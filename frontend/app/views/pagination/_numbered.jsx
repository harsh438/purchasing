import React from 'react';
import { Pagination } from 'react-bootstrap';

export default class NumberedPagination extends React.Component {
  componentWillMount() {
    this.setState({ activePage: this.props.activePage || 1 });
  }

  render() {
    return (
      <Pagination first
                  last
                  ellipsis
                  maxButtons={10}
                  bsSize="medium"
                  items={this.props.totalPages}
                  activePage={parseInt(this.props.activePage)}
                  onSelect={this.handleSelect.bind(this)} />
    );
  }

  handleSelect(e, selectedEvent) {
    e.preventDefault();
    this.setState({ activePage: selectedEvent.eventKey });
    this.props.index.loadPage(selectedEvent.eventKey);
  }
}
