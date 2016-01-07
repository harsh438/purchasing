import React from 'react';
import { getScript } from '../../utilities/get_script';

export default class Spreadsheet extends React.Component {
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
    return { data: [Array(this.props.columnHeaders.length).join('.').split('.')],
             colHeaders: this.props.columnHeaders,
             columns: this.props.columns,
             rowHeaders: true,
             columnSorting: true,
             contextMenu: true };
  }

  data() {
    return this.handsontable.getData();
  }

  clear() {
    this.handsontable.destroy();
    this.createHandsOnTable();
  }
}
