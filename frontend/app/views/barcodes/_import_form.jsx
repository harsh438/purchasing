import React from 'react';
import Spreadsheet from '../application/_spreadsheet';
import { map, values } from 'lodash';
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
                       columnHeaders={['Internal SKU', 'Barcode']}
                       columns={[{ data: 'sku' },
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
    if (this.state.success) {
      return renderSuccesses([`${this.props.barcodes.length} barcodes added successfully!`]);
    } else if (this.state.errors.length > 0) {
      return renderErrors([...this.state.errors,
                           ...this.state.nonexistantSkus,
                           ...this.state.duplicateBarcodes]);
    }
  }

  barcodes() {
    return map(this.refs.spreadsheet.data(), function ([sku, barcode]) {
      return { sku, barcode };
    });
  }

  handleSubmit(e) {
    e.preventDefault();
    this.props.onImport(this.barcodes(), this.setState.bind(this));
  }
}
