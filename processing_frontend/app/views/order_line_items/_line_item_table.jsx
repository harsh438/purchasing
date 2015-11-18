import React from 'react';
import { getScript } from '../../utilities/get_script';

export default class LineItemTable extends React.Component {
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

    this.handsOnTable = new window.Handsontable(this.refs.lineItemTable,
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
        contextMenu: true });
  }
}
