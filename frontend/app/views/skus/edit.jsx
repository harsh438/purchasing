import React from 'react';
import NotificationSystem from 'react-notification-system';
import SkusBarcodeForm from './_barcode_form';
import SkusBarcodeTable from './_barcode_table';
import { connect } from 'react-redux';
import { Link } from 'react-router';
import { assign } from 'lodash';
import { loadSku, addBarcodeToSku } from '../../actions/skus';
import { updateBarcode } from '../../actions/barcodes';
import { processNotifications } from '../../utilities/notification';

class SkusEdit extends React.Component {
  componentWillMount () {
    this.props.dispatch(loadSku(this.props.params.id));
  }

  componentWillReceiveProps(nextProps) {
    processNotifications.call(this, nextProps);
  }

  render() {
    return (
      <div className="skus_edit container-fluid" style={{ marginTop: '70px' }}>
        <NotificationSystem ref="notificationSystem" />
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
            {this.renderBarcodes()}
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

  renderBarcodes() {
    if (this.props.sku.barcodes.length > 0) {
      return (
        <SkusBarcodeTable barcodes={this.props.sku.barcodes}
                          onEditBarcode={this.handleEditBarcode.bind(this)} />
      );
    } else {
      return (
        <SkusBarcodeForm onAddBarcode={this.handleAddBarcode.bind(this)} />
      );
    }
  }

  handleAddBarcode(barcode) {
    this.props.dispatch(addBarcodeToSku(this.props.sku.id, barcode));
  }

  handleEditBarcode(barcode) {
    this.props.dispatch(updateBarcode(barcode));
  }
}

function applyState({ skus, notification, barcodes }) {
  return assign({}, skus, notification, barcodes);
}

export default connect(applyState)(SkusEdit);
