import React from 'react';

export class OrderRow extends React.Component {
  render() {
    return (
      <tr>
        <td>{this.props.id}</td>
        <td>{this.props.status}</td>
        <td>{this.props.createdAt}</td>
        <td>{this.props.updatedAt}</td>
      </tr>
    );
  }
}
