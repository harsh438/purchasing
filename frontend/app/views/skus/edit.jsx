import React from 'react';
import { connect } from 'react-redux';
import { Link } from 'react-router';
import { assign } from 'lodash';
import { loadSku } from '../../actions/skus';
import SkusBarcodeForm from './_barcode_form';
import SkusBarcodeTable from './_barcode_table';

class SkusEdit extends React.Component {
  componentWillMount () {
    this.props.dispatch(loadSku(this.props.params.id));
  }

  render() {
    return (
      <div className="skus_edit container-fluid" style={{ marginTop: '70px' }}>
        <div className="row" style={{ marginBottom: '20px' }}>
          <div className="col-md-6">
            <h1>
              <Link to="/skus">SKUs</Link>
              &nbsp;/&nbsp;
              {this.props.sku.sku}
            </h1>
          </div>
        </div>

        <div className="row">
          <div className="col-md-6">
            {this.renderFields()}
          </div>

          <div className="col-md-6">
            <SkusBarcodeForm />
            <SkusBarcodeTable />
          </div>
        </div>
      </div>
    );
  }

  renderFields() {
    const { sku } = this.props;

    return (
      <table className="table">
        <tbody>
          <tr>
            <th>Product Name</th>
            <td>{sku.productName}</td>
          </tr>
          <tr>
            <th>Brand</th>
            <td>{sku.vendorName}</td>
          </tr>
          <tr>
            <th>Season</th>
            <td>{sku.season}</td>
          </tr>
          <tr>
            <th>Manufacturer SKU</th>
            <td>{sku.manufacturerSku}</td>
          </tr>
          <tr>
            <th>Manufacturer Colour</th>
            <td>{sku.manufacturerColor}</td>
          </tr>
          <tr>
            <th>Manufacturer Size</th>
            <td>{sku.manufacturerSize}</td>
          </tr>
          <tr>
            <th>Colour</th>
            <td>{sku.color}</td>
          </tr>
          <tr>
            <th>Colour Family</th>
            <td>{sku.colorFamily}</td>
          </tr>
          <tr>
            <th>Size</th>
            <td>{sku.size}</td>
          </tr>
          <tr>
            <th>Size Scale</th>
            <td>{sku.sizeScale}</td>
          </tr>
          <tr>
            <th>Cost</th>
            <td>{sku.cost}</td>
          </tr>
          <tr>
            <th>RRP</th>
            <td>{sku.rrp}</td>
          </tr>
          <tr>
            <th>Category</th>
            <td>{sku.categoryName}</td>
          </tr>
          <tr>
            <th>Gender</th>
            <td>{sku.gender}</td>
          </tr>
        </tbody>
      </table>
    );
  }
}

function applyState({ skus }) {
  return skus;
}

export default connect(applyState)(SkusEdit);
