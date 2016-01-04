import React from 'react';

export default class SkusBarcodeTable extends React.Component {
  render() {
    return (
      <div className="panel panel-default">
        <div className="panel-heading">
          <h3 className="panel-title">Barcodes</h3>
        </div>
        <div className="panel-body">
          <em>No barcodes</em>
        </div>
      </div>
    );
  }
}
