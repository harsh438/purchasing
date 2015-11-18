import React from 'react';
import { Link } from 'react-router';

export class OrdersTableRow extends React.Component {
  componentWillMount() {
    this.state = { checked: false };
  }

  componentWillReceiveProps(nextProps) {
    if (nextProps.exported) {
      this.setState({ checked: false });
    }
  }

  render() {
    return (
      <tr>
        <td>
          <input type="checkbox"
                 checked={this.state.checked}
                 disabled={this.isDisabled()}
                 onChange={this.handleCheckboxChange.bind(this)}
                 value={this.props.id} />
        </td>
        <td>
          <Link to={`/orders/${this.props.id}/edit`}>
            {this.props.name}
          </Link>
        </td>
        <td className="text-center">{this.props.lineItems.length}</td>
        <td className="text-center">{this.props.createdAt}</td>
        <td className="text-center">{this.props.exportedAt || '✘'}</td>
      </tr>
    );
  }

  isDisabled() {
    return this.props.lineItems.length === 0 || this.props.exported;
  }

  handleCheckboxChange({ target }) {
    this.setState({ checked: target.checked });
    this.props.onToggleCheck(target.value);
  }
}
