import React from 'react';
import { connect } from 'react-redux';
import ImportForm from './_import_form';
import { importBarcodes } from '../../actions/barcodes';

class BarcodesIndex extends React.Component {
  render() {
    return (
      <div className="container-fluid" style={{ marginTop: '70px' }}>
        <div className="row" style={{ marginBottom: '20px' }}>
          <div className="col-md-12">
            <h1>Import Barcodes</h1>
          </div>
        </div>

        <div className="row">
          <div className="col-md-12">
            <ImportForm onImport={this.handleImport.bind(this)} {...this.props} />
          </div>
        </div>
      </div>
    );
  }

  handleImport(barcodes) {
    this.props.dispatch(importBarcodes(barcodes));
  }
}

function applyState({ barcodes }) {
  return barcodes;
}

export default connect(applyState)(BarcodesIndex);
