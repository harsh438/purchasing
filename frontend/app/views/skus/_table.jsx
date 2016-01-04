import React from 'react';
import { map } from 'lodash';
import { Link } from 'react-router';

export default class SkusTable extends React.Component {
  render() {
    return (
      <table className="table table-hover">
        <thead>
          <tr>
            <th>SKU</th>
            <th>Product Name</th>
            <th>Brand</th>
            <th>Season</th>
            <th>Manufacturer SKU</th>
            <th>Manufacturer Colour</th>
            <th>Manufacturer Size</th>
            <th>Colour</th>
            <th>Colour Family</th>
            <th>Size</th>
            <th>Size Scale</th>
            <th>Cost</th>
            <th>RRP</th>
            <th>Category</th>
            <th>Gender</th>
          </tr>
        </thead>
        <tbody>
          {this.renderRows()}
        </tbody>
      </table>
    );
  }

  renderRows() {
    return map(this.props.skus, (sku, i) => {
      return (
        <tr key={i}>
          <td>
            <Link to={`/skus/${sku.id}/edit`}>{sku.sku}</Link>
          </td>
          <td>{sku.productName}</td>
          <td>{sku.vendorName}</td>
          <td>{sku.season}</td>
          <td>{sku.manufacturerSku}</td>
          <td>{sku.manufacturerColor}</td>
          <td>{sku.manufacturerSize}</td>
          <td>{sku.color}</td>
          <td>{sku.colorFamily}</td>
          <td>{sku.size}</td>
          <td>{sku.sizeScale}</td>
          <td>{sku.cost}</td>
          <td>{sku.rrp}</td>
          <td>{sku.categoryName}</td>
          <td>{sku.gender}</td>
        </tr>
      );
    });
  }
}
