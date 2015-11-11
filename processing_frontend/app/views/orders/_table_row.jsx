import React from 'react';
import { Link } from 'react-router';

export class OrdersTableRow extends React.Component {
  render() {
    return (
      <tr>
        <td>
          <Link to={`/orders/${this.props.id}/edit`}>
            Shopping list {this.props.id}
          </Link>
        </td>
        <td className="text-center">{this.props.createdAt}</td>
        <td className="text-center">{this.props.exportedAt || '✘'}</td>
      </tr>
    );
  }
}
