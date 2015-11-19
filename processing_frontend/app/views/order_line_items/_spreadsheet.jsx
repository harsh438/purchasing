import React from 'react';
import { getScript } from '../../utilities/get_script';

export default class OrderLineItemsSpreadsheet extends React.Component {
  componentWillMount() {
    getScript('/assets/handsontable.full.js', this.createHandsOnTable.bind(this));
  }

  render() {
    return (
      <div ref="spreadsheet"></div>
    );
  }

  createHandsOnTable() {
    if (!this.refs.spreadsheet) return;
    this.handsontable = new window.Handsontable(this.refs.spreadsheet, this.config());
  }

  config() {
    return { data: [['', '', '', '']],
             colHeaders: ['Internal SKU', 'Quantity', 'Discount %', 'Drop Date'],
             columns: [
               { data: 'internalSku' },
               { data: 'quantity', type: 'numeric' },
               { data: 'discount', type: 'numeric' },
               { data: 'dtopDate', type: 'date', dateFormat: 'YYYY-MM-DD', correctFormat: true }
             ],
             rowHeaders: true,
             columnSorting: true,
             contextMenu: true };
  }

  data() {
    return this.handsontable.getData();
  }

  clear() {
    return this.handsontable.clear();
  }
}
