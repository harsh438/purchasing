import React from 'react';
import VirtualRowEdit from './_virtual_row_edit';

export default class UnitPriceRowEdit extends VirtualRowEdit {
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
