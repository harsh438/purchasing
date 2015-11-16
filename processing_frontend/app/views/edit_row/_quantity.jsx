import React from 'react';
import AbstractRowEdit from './_abstract';

export default class EditRowQuantity extends AbstractRowEdit {
  renderInput() {
    return (
      <input type="number"
             className="form-control"
             onChange={this.handleChange.bind(this, 'qty')}
             value={this.state.value} name="qty" />
    );
  }
}

EditRowQuantity.defaultProps = { title: 'Editing Quantity',
                                 fieldKey: 'quantity',
                                 labelValue: 'Qty' };
