import React from 'react';
import { map } from 'lodash';
import { packingListName } from '../../utilities/packing_list';

export default class RefusedDeliveriesTable extends React.Component {
  render() {
    return (
      <table className="table table-striped">
        <thead>
          <tr>
            <th>Date</th>
            <th>Courier</th>
            <th>Brand</th>
            <th>Pallets</th>
            <th>Pallets</th>
            <th>Info/Pos</th>
            <th>Reason for refusal</th>
          </tr>
        </thead>
        <tbody>
          {this.renderRows()}
        </tbody>
      </table>
    );
  }

  renderRows() {
    return map(this.props.refusedDeliveries, this.renderRow, this);
  }

  renderRow({ id, deliveryDate, courier, brand, pallets, boxes, info, refusalReason }) {
    return (
      <tr key={id}>
        <td>{deliveryDate}</td>
        <td>{courier}</td>
        <td>{brand}</td>
        <td>{pallets}</td>
        <td>{boxes}</td>
        <td>{info}</td>
        <td>{refusalReason}</td>
      </tr>
    );
  }
}
