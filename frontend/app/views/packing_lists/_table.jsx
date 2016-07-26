import React from 'react';
import { map } from 'lodash';
import Qs from 'qs';
import { packingListName } from '../../utilities/packing_list';

export default class PackingListsTable extends React.Component {
  render() {
    return (
      <table className="table table-striped">
        <thead>
          <tr>
            <th>Brand</th>
            <th>GRN</th>
            <th>PO Numbers</th>
            <th>Delivery date</th>
            <th>Packing list</th>
          </tr>
        </thead>
        <tbody>
          {this.renderRows()}
        </tbody>
      </table>
    );
  }

  renderRows() {
    return map(this.props.packingLists, this.renderRow, this);
  }

  renderRow({ grn, vendorName, deliveryDate, purchaseOrderIds, packingListUrls, grnPaperUrl, checkSheetUrl }) {
    return (
      <tr key={grn}>
        <td>{vendorName}</td>
        <td>{grn}</td>
        <td>{purchaseOrderIds.join(', ')}</td>
        <td>{deliveryDate}</td>
        <td>{map(packingListUrls, this.renderPackingListUrl, this)}</td>
        <td>
          <a href={this.checkSheet(grn)}
             target="_blank"
             className="btn btn-default">Print goods in check sheet</a>
        </td>
        <td>
          <a href={this.grnPaper(grn)}
             target="_blank"
             className="btn btn-default">Print GRN paper</a>
        </td>
      </tr>
    );
  }

  renderPackingListUrl(url) {
    return (
      <div key={url}>
        <a href={url} target="_blank">{packingListName(url)}</a>
      </div>
    );
  }

  grnPaper(grn) {
    const query = Qs.stringify({ type: 'grn' });
    return '/api/packing_lists/'+grn+'.pdf?' + query;
  }

  checkSheet(grn) {
    const query = Qs.stringify({ type: 'check_sheet' });
    return '/api/packing_lists/'+grn+'.pdf?' + query;
  }
}
