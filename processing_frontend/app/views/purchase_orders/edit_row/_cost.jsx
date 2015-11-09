import React from 'react';
import AbstractEditRow from './_abstract';

export default class EditRowCost extends AbstractEditRow {
  renderInput() {
    return (
      <div className="input-group">
        <div className="input-group-addon">£</div>
          <input type="text"
                 className="form-control"
                 onChange={this.handleChange.bind(this, 'cost')}
                 value={this.state.value} name="cost" />
      </div>
    );
  }
}
