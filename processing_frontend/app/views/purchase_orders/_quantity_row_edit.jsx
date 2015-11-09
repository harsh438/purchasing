import React from 'react';
import VirtualRowEdit from './_virtual_row_edit';

export default class QuantityRowEdit extends VirtualRowEdit {
  renderInput() {
    return (
      <input type="number"
             className="form-control"
             onChange={this.handleChange.bind(this, 'qty')}
             value={this.state.value} name="qty" />
    );
  }
}
