import React from 'react';
import { Link } from 'react-router';
import Spreadsheet from '../application/_spreadsheet';
import { map, values, flatten } from 'lodash';
import { renderSuccesses, renderErrors } from '../../utilities/dom';

export default class ImportForm extends React.Component {
  componentWillMount() {
    this.state = { success: false,
                   errors: [],
                   nonexistantSkus: [],
                   duplicateBarcodes: [] };
  }

  render() {
    return (
      <form className="form" onSubmit={this.handleSubmit.bind(this)}>
        {this.renderFlashes()}

        <div className="col-md-4">
          <Spreadsheet ref="spreadsheet"
                       columnHeaders={['Internal SKU', 'Brand Size', 'Barcode']}
                       columns={[{ data: 'sku' },
                                 { data: 'brandSize' },
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

  renderFlashes() {
    if (this.state.success && this.props.barcodes.length > 0) {
      return renderSuccesses([`${this.props.barcodes.length} barcodes added successfully!`,
                              ...this.successfulBarcodesAdded()]);
    } else if (this.state.errors.length > 0) {
      return renderErrors([...this.state.errors,
                           ...this.state.nonexistantSkus,
                           ...this.state.duplicateBarcodes]);
    }
  }

  barcodes() {
    return map(this.refs.spreadsheet.data(), function ([sku, brandSize, barcode]) {
      return { sku, brandSize, barcode };
    });
  }

  successfulBarcodesAdded() {
    return flatten(map(this.props.barcodes, function(barcode) {
      return (
        <Link to={`/skus/${barcode.sku_id}/edit`}>Added barcode {barcode.barcode}.</Link>
      );
    }));
  }

  handleSubmit(e) {
    e.preventDefault();
    this.props.onImport(this.barcodes(), this.setState.bind(this));
  }
}
