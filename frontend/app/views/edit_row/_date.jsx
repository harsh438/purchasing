import React from 'react';
import AbstractRowEdit from './_abstract';

export default class EditRowDate extends AbstractRowEdit {
  renderInput() {
    return (
      <input type="date"
             className="form-control"
             onChange={this.handleChange.bind(this, 'dropDate')}
             value={this.state.value} name="dropDate" />
    );
  }
}

EditRowDate.defaultProps = { title: 'Editing Drop Date',
                             fieldKey: 'dropDate',
                             labelValue: 'Drop Date' };
