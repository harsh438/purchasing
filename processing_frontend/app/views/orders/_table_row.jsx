import React from 'react';

export class OrdersTableRow extends React.Component {
  render() {
    return (
      <tr>
        <td>Shopping list {this.props.id}</td>
        <td className="text-center">{this.props.createdAt}</td>
        <td className="text-center">{this.props.exportedAt || '✘'}</td>
      </tr>
    );
  }
}
