import React from 'react';
import DropZone from 'react-dropzone';
import { renderSelectOptions } from '../../utilities/dom';
import { map } from 'lodash';
import { Nav, NavItem } from 'react-bootstrap';
import { packingListName } from '../../utilities/packing_list';

export default class GoodsReceivedNoticesEdit extends React.Component {
  componentWillMount() {
    const { id, deliveryDate, pallets } = this.props.goodsReceivedNotice;
    const tab = 'purchaseOrders';

    this.state = { id,
                   deliveryDate,
                   tab,
                   totalPallets: pallets,
                   goodsReceivedNotice: this.props.goodsReceivedNotice };

    this.setVendorId(this.firstVendorId());
  }

  componentWillReceiveProps(nextProps) {
    let { id, deliveryDate, pallets } = nextProps.goodsReceivedNotice;
    deliveryDate = deliveryDate.split('/').reverse().join('-');

    this.setState({ id,
                    deliveryDate,
                    combineFrom: '',
                    totalPallets: pallets,
                    goodsReceivedNotice: nextProps.goodsReceivedNotice,
                    onPackingListUpload: false,
                    packingFileName: null });

    if (this.props.goodsReceivedNotice.id !== id) {
      this.setVendorId(this.firstVendorId(nextProps));
      this.setState({ userId: '' });
    }
  }

  render() {
    return (
      <div className="grn_edit">
        <div className="panel panel-default panel-info">
          <div className="panel-heading clearfix">
            <h3 className="panel-title pull-left">
              GRN #{this.state.goodsReceivedNotice.id}
              <br />
              <small>By {this.state.goodsReceivedNotice.userName}</small>
            </h3>

            <span className="pull-right">
              <span className="badge" title="Units">{this.state.goodsReceivedNotice.units} U</span>&nbsp;
              <span className="badge" title="Cartons">{this.state.goodsReceivedNotice.cartons} C</span>&nbsp;
              <span className="badge" title="Pallets">{this.state.goodsReceivedNotice.pallets} P</span>&nbsp;

              <a style={{ cursor: 'pointer', marginLeft: '10px' }}
                 className="glyphicon glyphicon-remove"
                 onClick={this.props.onClose}
                 aria-label="close"></a>
            </span>
          </div>

          <div className="panel-body">
            <Nav bsStyle="tabs"
                 activeKey={this.state.tab}
                 onSelect={this.handleTabChange.bind(this)}
                 style={{ marginBottom: '10px' }}>
              <NavItem eventKey="purchaseOrders">Purchase orders</NavItem>
              <NavItem eventKey="packingLists">Packing lists</NavItem>
              <NavItem eventKey="pallets">Pallets</NavItem>
              {this.props.advanced && <NavItem eventKey="advanced">Advanced</NavItem>}
            </Nav>

            {this.renderTab()}
          </div>
        </div>
      </div>
    );
  }

  renderTab() {
    switch (this.state.tab) {
    case 'purchaseOrders':
      return (
        <div>
          {this.renderAddPurchaseOrderForm()}

          <div style={{ marginTop: '30px' }}>
            {this.renderPurchaseOrders()}
          </div>
        </div>
      );
    case 'packingLists':
      return this.renderPackingLists();
    case 'pallets':
      return this.renderChangePalletsForm();
    case 'advanced':
      return this.renderAdvanced();
    }
  }

  renderAddPurchaseOrderForm() {
    return (
      <form onChange={this.handleChange.bind(this)}
            onSubmit={this.handleSubmit.bind(this)}>
        <div className="form-group">
          <select className="form-control"
                  id="userId"
                  name="userId"
                  value={this.state.userId}
                  required>
            <option value=""> -- select user -- </option>
            {renderSelectOptions(this.props.users)}
          </select>
        </div>

        <div className="form-group">
          <select className="form-control"
                  id="vendorId"
                  value={this.state.vendorId}
                  onChange={this.handleVendorChange.bind(this)}
                  required>
            <option value=""> -- select brand -- </option>
            {renderSelectOptions(this.props.vendors)}
          </select>
        </div>

        <div>
          <div className="form-group grn_edit__form_group--purchase_order">
            <label htmlFor="purchaseOrderId">PO #</label>
            <select className="form-control"
                    id="purchaseOrderId"
                    name="purchaseOrderId"
                    value={this.state.purchaseOrderId}
                    required>
              <option value=""> -- select purchase order -- </option>
              {renderSelectOptions(map(this.props.purchaseOrderList, 'id'))}
            </select>
          </div>

          <div className="form-group grn_edit__form_group--units">
            <label htmlFor="units">Units</label>
            <input type="number"
                   name="units"
                   className="form-control"
                   value={this.state.units}
                   required />
          </div>

          <div className="form-group grn_edit__form_group--cartons">
            <label htmlFor="cartons">Cartons</label>
            <input type="number"
                   name="cartons"
                   className="form-control"
                   value={this.state.cartons}
                   required />
          </div>

          <div className="form-group grn_edit__form_group--pallets">
            <label htmlFor="pallets">Pallets</label>
            <input type="number"
                   name="pallets"
                   className="form-control"
                   step="0.0001"
                   value={this.state.pallets}
                   required />
          </div>

          <div className="text-right">
            <button className="btn btn-success">Add</button>
          </div>
        </div>
      </form>
    );
  }

  renderPurchaseOrders() {
    if (this.state.goodsReceivedNotice.goodsReceivedNoticeEvents.length === 0) {
      return (
        <i>No purchase orders currently.</i>
      );
    }

    return (
      <table className="table table-striped table-condensed">
        <thead>
          <tr>
            <th colSpan="3">&nbsp;</th>
          </tr>
        </thead>
        <tbody>
          {map(this.state.goodsReceivedNotice.goodsReceivedNoticeEvents, this.renderPurchaseOrder, this)}
        </tbody>
      </table>
    );
  }

  renderPurchaseOrder(goodsReceivedNoticeEvent) {
    return (
      <tr className={this.goodsReceivedNoticeEventClass(goodsReceivedNoticeEvent)}
          key={goodsReceivedNoticeEvent.id}>
        <td style={{ fontSize: '.9em' }}>
          #{goodsReceivedNoticeEvent.purchaseOrderId}
          &nbsp;–&nbsp;
          {goodsReceivedNoticeEvent.vendorName}

          <div>
            <small>By {goodsReceivedNoticeEvent.userName}</small>
          </div>
        </td>

        <td className="text-right">
          <span className="badge"
                title="Units">{goodsReceivedNoticeEvent.units} U</span>&nbsp;
          <span className="badge"
                title="Cartons">{goodsReceivedNoticeEvent.cartons} C</span>&nbsp;
          <span className="badge"
                title="Pallets">{goodsReceivedNoticeEvent.pallets} P</span>&nbsp;

          <button className="btn btn-sm btn-danger"
                  onClick={this.handleDeletePurchaseOrder.bind(this, goodsReceivedNoticeEvent.id)}>
            Delete
          </button>
        </td>
      </tr>
    );
  }

  renderPackingLists() {
    const attachments = this.state.goodsReceivedNotice.packingListUrls || [];

    return (
      <div>
        {this.renderPackingListUpload()}
        <br />
        <br />
        <table className="table table-striped table-condensed">
          <tbody>
            {attachments.map(this.renderPackingList.bind(this))}
          </tbody>
        </table>
      </div>
    );
  }

  renderPackingList(packingListUrl) {
    if (!packingListUrl) return;

    return (
      <tr key={packingListUrl} style={{ wordBreak: 'break-all' }}>
        <td>
          <span className="glyphicon glyphicon-file"></span>&nbsp;
          <a target="_blank" href={packingListUrl}>
            {packingListName(packingListUrl)}
          </a>&nbsp;
          <button onClick={this.props.onDeletePackingList.bind(this, { goodsReceivedNotice: this.props.goodsReceivedNotice,
                                                                       packingListUrl: packingListUrl })}
                  className="btn btn-sm btn-danger pull-right">Delete</button>
        </td>
      </tr>
    );
  }

  renderPackingListUpload() {
    return (
      <div>
        <form onSubmit={this.handleFileUploadSubmit.bind(this)}>
          <DropZone multiple={false}
                    onDrop={this.handlePackingFileUpload.bind(this)}
                    style={{ color: '#999', padding: '30px', border: '2px dashed #999' }}
                    accept=".jpg,.jpeg,.png,.pdf,.xls,.xlsx,.eml,.doc,.docx">
            <div>Add a new packing list. Try dropping some file here, or click to select file to upload.</div>
            {this.renderPackingListUploadText()}
          </DropZone>
          <br />
          {this.renderPackingListUploadButton()}
        </form>
      </div>
    );
  }

  renderPackingListUploadButton() {
    if (!this.state.onPackingListUpload) {
      return (<input type="submit" className="btn btn-success pull-right" value="Upload" />);
    } else {
      return (<input disabled type="submit" className="btn btn-success pull-right" value="Uploading..." />);
    }
  }

  renderPackingListUploadText() {
    if (this.state.packingFileName) {
      return (
        <div style={{ margin: '5px 10px 0 10px' }}>
          <span className="glyphicon glyphicon-open-file"></span>&nbsp;
          <span style={{ color: 'grey' }}>File to upload: {this.state.packingFileName}</span>
        </div>
      );
    }
  }

  renderChangePalletsForm() {
    return (
      <form onChange={this.handleChange.bind(this)}
            onSubmit={this.handleChangePalletsSubmit.bind(this)}>
        <div className="form-group">
          <label htmlFor="pallets">Total pallets:</label>
          <input className="form-control"
                 type="number"
                 id="pallets"
                 name="totalPallets"
                 step="0.0001"
                 value={this.state.totalPallets}
                 required />
        </div>

        <div className="text-right">
          <button className="btn btn-warning">Update pallets</button>
        </div>
      </form>
    );
  }

  renderAdvanced() {
    return (
      <div>
        <form onChange={this.handleChange.bind(this)}
              onSubmit={this.handleChangeDateSubmit.bind(this)}>
          <div className="form-group">
            <label htmlFor="deliveryDate">Delivery date</label>
            <input className="form-control"
                   type="date"
                   id="deliveryDate"
                   name="deliveryDate"
                   value={this.state.deliveryDate}
                   required />
          </div>

          <div className="text-right">
            <button className="btn btn-warning">Change date</button>
          </div>
        </form>

        <form onChange={this.handleChange.bind(this)}
              onSubmit={this.handleCombine.bind(this)}>
          <div className="form-group">
            <label htmlFor="combineFrom">Combine with GRN</label>
            <input className="form-control"
                   id="combineFrom"
                   name="combineFrom"
                   placeholder="GRN # you want to move POs from"
                   value={this.state.combineFrom}
                   required />
          </div>

          <div className="text-right">
            <button className="btn btn-warning">Combine</button>
          </div>
        </form>

        <div>
          <p>If you a really sure:</p>
          <button className="btn btn-danger"
                  onClick={this.handleDelete.bind(this)}>Delete GRN</button>
        </div>
      </div>
    );
  }

  goodsReceivedNoticeEventClass({ status }) {
    let className = 'grn_edit__purchase_order';

    switch (status) {
    case 'late':
      className += ' danger';
      break;
    case 'received':
      className += ' success';
      break;
    case 'delivered':
      className += ' warning';
      break;
    }

    return className;
  }

  calculatePalletsFromCartons(cartons) {
    return parseInt(cartons, 10) / 16;
  }

  firstVendorId({ goodsReceivedNotice } = this.props) {
    const { goodsReceivedNoticeEvents } = goodsReceivedNotice;

    if (goodsReceivedNoticeEvents.length > 0) {
      return goodsReceivedNoticeEvents[0].purchaseOrder.vendorId;
    }
  }

  setVendorId(vendorId) {
    this.setState({ vendorId });
    this.props.onVendorChange(vendorId);
  }

  handleChange({ target }) {
    switch (target.name) {
    case 'cartons':
      this.setState({ pallets: this.calculatePalletsFromCartons(target.value),
                      cartons: target.value });
      break;
    default:
      this.setState({ [target.name]: target.value });
    }
  }

  handlePackingFileUpload(files) {
    const self = this;
    const reader = new FileReader();
    const file = files[0];

    reader.onload = function (upload) {
      let grn = self.state.goodsReceivedNotice;
      grn.packingLists = grn.packingLists || [];
      grn.packingLists.push({
        list: upload.target.result,
        list_file_name: file.name,
      });
      self.setState({ goodsReceivedNotice: grn, packingFileName: file.name });
    };

    reader.readAsDataURL(file);
  }

  handleFileUploadSubmit(e) {
    e.preventDefault();
    this.setState({ onPackingListUpload: true });
    this.props.onSave(this.state.goodsReceivedNotice);
  }

  handleVendorChange(e) {
    e.stopPropagation();
    this.setVendorId(e.target.value);
  }

  handleSubmit(e) {
    e.preventDefault();
    this.props.onPurchaseOrderAdd(this.state);
  }

  handleDelete() {
    if (confirm('Are you sure you wish to delete this GRN?') && confirm('Really?')) {
      this.props.onDelete(this.state.id);
    }
  }

  handleChangePalletsSubmit(e) {
    e.preventDefault();
    const { id, totalPallets } = this.state;
    this.props.onSave({ id, pallets: totalPallets });
  }

  handleChangeDateSubmit(e) {
    e.preventDefault();
    const { id, deliveryDate } = this.state;
    this.props.onSave({ id, deliveryDate });
  }

  handleCombine(e) {
    e.preventDefault();
    const { id, combineFrom } = this.state;
    this.props.onCombine({ from: combineFrom, to: id });
  }

  handleDeletePurchaseOrder(id) {
    if (confirm('Are you sure you wish to remove this Purchase Order?')) {
      this.props.onPurchaseOrderDelete(id);
    }
  }

  handleTabChange(tab) {
    this.setState({ tab });
  }
}
