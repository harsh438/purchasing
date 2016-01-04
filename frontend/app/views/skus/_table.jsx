import React from 'react';
import { map } from 'lodash';

export default class SkusTable extends React.Component {
  render() {
    return (
      <table className="table table-hover">
        <thead>
          <tr>
            <th>SKU</th>
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
            {sku.sku}
          </td>
        </tr>
      );
    });
  }
}
