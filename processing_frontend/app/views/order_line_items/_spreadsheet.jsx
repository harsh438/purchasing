import React from 'react';
import { getScript } from '../../utilities/get_script';
import { filter } from 'lodash';

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
               { data: 'discount', type: 'numeric', format: '0.0' },
               { data: 'dropDate', type: 'date', dateFormat: 'YYYY-MM-DD', correctFormat: true }
             ],
             rowHeaders: true,
             columnSorting: true,
             contextMenu: true };
  }

  data() {
    return filter(this.handsontable.getData(), function (row) {
      return row.internalSku && row.quantity >= 1 && row.dropDate;
    });
  }

  clear() {
    this.handsontable.destroy();
    this.createHandsOnTable();
  }
}
