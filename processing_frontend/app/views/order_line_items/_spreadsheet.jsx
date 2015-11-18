import React from 'react';
import { getScript } from '../../utilities/get_script';
import { partial } from 'lodash';

export default class OrderLineItemsSpreadsheet extends React.Component {
  componentWillMount() {
    getScript('/assets/handsontable.full.js', this.createHandsOnTable.bind(this));
  }

  render() {
    return (
      <div ref="lineItemTable"></div>
    );
  }

  createHandsOnTable() {
    if (!this.refs.lineItemTable) return;

    new window.Handsontable(this.refs.lineItemTable,
      { data: [['', '', '', '']],
        colHeaders: ['Internal SKU', 'Quantity', 'Discount %', 'Drop Date'],
        columns: [
          { data: 'internalSku' },
          { data: 'quantity', type: 'numeric' },
          { data: 'discount', type: 'numeric' },
          { data: 'dtopDate', type: 'date', dateFormat: 'YYYY-MM-DD', correctFormat: true }
        ],
        rowHeaders: true,
        columnSorting: true,
        contextMenu: true,
        afterChange: partial(this.handleChange, this.props.onChange) });
  }

  handleChange (onChange, changes, source) {
    onChange(this.getData());
  }
}
