import React from 'react';
import AbstractRowEdit from './_abstract';

export default class EditRowDiscount extends AbstractRowEdit {
  renderInput() {
    return (
      <input type="number"
             className="form-control"
             onChange={this.handleChange.bind(this, 'discount')}
             step="0.01"
             value={this.state.value} name="discount" />
    );
  }
}

EditRowDiscount.defaultProps = { title: 'Editing Discount',
                                 fieldKey: 'discount',
                                 labelValue: 'Discount' };
