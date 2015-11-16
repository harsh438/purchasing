import React from 'react';
import AbstractEditRow from './_abstract';

export default class EditRowCost extends AbstractEditRow {
  renderInput() {
    return (
      <div className="input-group">
        <div className="input-group-addon">£</div>
          <input type="number"
                 step="0.01"
                 className="form-control"
                 onChange={this.handleChange.bind(this, 'cost')}
                 value={this.state.value} name="cost" />
      </div>
    );
  }
}

EditRowCost.defaultProps = { title: 'Editing Cost',
                             fieldKey: 'cost',
                             labelValue: 'Unit Price' };
