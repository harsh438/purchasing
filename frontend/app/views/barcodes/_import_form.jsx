import React from 'react';
import Spreadsheet from '../application/_spreadsheet';

export default class ImportForm extends React.Component {
  render() {
    return (
      <form className="form">
        <div className="col-md-4">
          <Spreadsheet ref="spreadsheet"
                       columnHeaders={['Internal SKU', 'Barcode']}
                       columns={[{ data: 'internalSku' },
                                 { data: 'barcode' }]} />
        </div>

        <div className="form-group col-md-2">
          <button className="btn btn-success">
            Import
          </button>
        </div>
      </form>
    );
  }
}
