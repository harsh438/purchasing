import React from 'react';
import DropZone from 'react-dropzone';
import RadioGroup from 'react-radio-group';
import { renderSelectOptions } from '../../utilities/dom';
import { map, every, filter, some } from 'lodash';
import { Nav, NavItem } from 'react-bootstrap';
import { packingListName } from '../../utilities/packing_list';
import GoodsReceivedNoticesTotalsForm from './_totals_form';

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
    this.setState({ purchaseOrderLoading: false });
    let { id, deliveryDate, pallets } = nextProps.goodsReceivedNotice;
    deliveryDate = deliveryDate.split('/').reverse().join('-');

    this.setState({ id,
                    deliveryDate,
                    purchaseOrderId: '',
                    units: '',
                    cartons: '',
                    pallets: '',
                    combineFrom: '',
                    totalPallets: pallets,
                    goodsReceivedNotice: nextProps.goodsReceivedNotice,
                    onPackingListUpload: false,
                    packingFileNames: [] });

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
              <NavItem eventKey="purchaseOrders">POs</NavItem>
              <NavItem eventKey="packingLists">Packing lists</NavItem>
              <NavItem eventKey="totals">Totals</NavItem>
              <NavItem eventKey="deliveryCondition">Condition</NavItem>
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
    case 'totals':
      return <GoodsReceivedNoticesTotalsForm onChange={this.handleChange.bind(this)}
                                             onSave={this.props.onSave.bind(this)}
                                             grnId={this.state.id}
                                             totalPallets={this.state.totalPallets} />;
    case 'advanced':
      return this.renderAdvanced();
    case 'deliveryCondition':
      return this.renderDeliveryCondition();
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
            {this.renderPurchaseOrdersLoading()}
            <select className="form-control"
                    id="purchaseOrderId"
                    name="purchaseOrderId"
                    value={this.state.purchaseOrderId}
                    required
                    disabled={this.state.purchaseOrderLoading}>
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

  renderPurchaseOrdersLoading() {
    if (!this.state.purchaseOrderLoading) { return ;}
    return (
      <div style={{ position: 'absolute' }}>
              <i className="glyphicon glyphicon-refresh spin"
                 style={{ position:'relative', top: '9px', left: '5px' }}></i>
      </div>
    );
  }

  renderPurchaseOrders() {
    if (this.state.goodsReceivedNotice.goodsReceivedNoticeEvents.length === 0) {
      return (
        <i>No purchase orders currently.</i>
      );
    }

    return (
      <section>
        <table className="table table-striped table-condensed">
          <thead>
            <tr>
              <th colSpan="3">
                <input type="checkbox"
                  name="checkAllGRNEvents"
                  id="checkAllGRNEvents"
                  checked={this.allEventsReceivedForNotice(this.props.goodsReceivedNotice)}
                  onChange={this.handleAllReceivedCheckboxToggle.bind(this)} />
                <label htmlFor="checkAllGRNEvents"
                       style={{ fontSize: '12px', paddingLeft: '10px' }}>
                  Check All
                </label>
              </th>
            </tr>
          </thead>
          <tbody>
            {map(this.state.goodsReceivedNotice.goodsReceivedNoticeEvents, this.renderPurchaseOrder, this)}
          </tbody>
        </table>
        <section>
          <div className="text-right">
            <button className="btn btn-success"
                    onClick={this.handleMarkCheckedAsReceived.bind(this)}
                    disabled={this.canMarkCheckedAsReceived()}>
              Mark as Received
            </button>
          </div>
        </section>
      </section>
    );
  }

  renderPurchaseOrder(goodsReceivedNoticeEvent, index) {
    return (
      <tr className={this.goodsReceivedNoticeEventClass(goodsReceivedNoticeEvent)}
          key={goodsReceivedNoticeEvent.id}>
        <td style={{ verticalAlign: 'middle' }}>
          <input type="checkbox"
                 checked={goodsReceivedNoticeEvent.checked}
                 onChange={this.handleReceivedCheckboxChange.bind(this, index)} />
        </td>
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
            <span className="glyphicon glyphicon-remove" aria-hidden="true"></span>
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
          <DropZone multiple
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
    if (this.state.packingFileNames.length) {
      return this.state.packingFileNames.map((packingName) => {
        return (
          <div key={packingName} style={{ margin: '5px 10px 0 10px' }}>
            <span className="glyphicon glyphicon-open-file"></span>&nbsp;
            <span style={{ color: 'grey' }}>File to upload: {packingName}</span>
          </div>
        );
      });
    }
  }

  renderDeliveryCondition() {
    let condition = this.state.goodsReceivedNotice.packingCondition;
    return (
      <div>
        <form onChange={this.handleConditionFormChange.bind(this)}>
          <table className="table table-striped table-condensed"
                 style={{ fontSize: '12px' }}>
            <thead>
              <tr>
                <th colSpan="6">
                  Delivery Condition
                </th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td colSpan="3">Delivery Booked In?</td>
                <td colSpan="3">
                  {this.renderConditionRadio(condition, 'booked_in')}
                </td>
              </tr>
              <tr>
                <td colSpan="3">Delivery Arrived Correctly?</td>
                <td colSpan="3">
                  {this.renderConditionRadio(condition, 'arrived_correctly')}
                </td>
              </tr>
              <tr>
                <td colSpan="3">Packing List Received?</td>
                <td colSpan="3">
                  {this.renderConditionRadio(condition, 'packing_list_received')}
                </td>
              </tr>
              <tr>
                <td colSpan="3">Any Items in Quarantine?</td>
                <td colSpan="3">
                  {this.renderConditionRadio(condition, 'items_in_quarantine')}
                </td>
              </tr>
              <tr>
                <td colSpan="3">Cartons in Good Condition?</td>
                <td colSpan="3">
                  {this.renderConditionRadio(condition, 'cartons_good_condition')}
                </td>
              </tr>
              <tr>
                <td colSpan="3">GRN or PO Marked on Cartons?</td>
                <td colSpan="3">
                  {this.renderConditionRadio(condition, 'grn_or_po_marked_on_cartons')}
                </td>
              </tr>
              <tr>
                <td colSpan="3">Cartons Palletised Correctly (16 or more)?</td>
                <td colSpan="3">
                  {this.renderConditionRadio(condition, 'cartons_palletised_correctly')}
                </td>
              </tr>
            </tbody>
          </table>
        </form>
      </div>
    );
  }

  renderConditionRadio(condition, key) {
    return (
      <RadioGroup name={key}
                  selectedValue={condition[key].toString()}
                  onChange={() => 'noop'}>
        {Radio => (
          <div className="form-group" style={{ margin: 0 }}>
            <label className="status-label">
              <Radio value="1" /> Yes
            </label>
            <label className="status-label">
              <Radio value="0" /> No
            </label>
          </div>
        )}
      </RadioGroup>
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
    this.setState({ purchaseOrderLoading: true });
    this.props.onVendorChange(vendorId);
  }

  handleAllReceivedCheckboxToggle() {
    const notice = this.state.goodsReceivedNotice;
    const allReceived = this.allEventsReceivedForNotice(notice);
    const mixedReceived = this.mixedReceivedForNotice(notice);
    const checked = mixedReceived || !allReceived;

    notice.goodsReceivedNoticeEvents.forEach(function (e, index) {
      notice.goodsReceivedNoticeEvents[index].checked = checked;
    });

    this.setState({ goodsReceivedNotice: notice });
  }

  handleReceivedCheckboxChange(index) {
    const notice = this.state.goodsReceivedNotice;
    const checked = !notice.goodsReceivedNoticeEvents[index].checked;

    notice.goodsReceivedNoticeEvents[index].checked = checked;

    this.setState({ goodsReceivedNotice: notice });
  }

  handleMarkCheckedAsReceived() {
    const notice = this.state.goodsReceivedNotice;
    const allEventsReceived = this.allEventsReceivedForNotice(notice);
    const confirmed = !allEventsReceived || confirm('Are you sure you want to mark all POs as received?');
    if (!confirmed) return;

    const updatedEvents = filter(notice.goodsReceivedNoticeEvents, 'checked');
    this.props.onMarkEventsAsReceived(notice.id, updatedEvents);
  }

  canMarkCheckedAsReceived() {
    return !some(this.state.goodsReceivedNotice.goodsReceivedNoticeEvents, 'checked');
  }

  allEventsReceivedForNotice(goodsReceivedNotice) {
    return every(map(goodsReceivedNotice.goodsReceivedNoticeEvents, 'checked'));
  }

  mixedReceivedForNotice(goodsReceivedNotice) {
    const events = goodsReceivedNotice.goodsReceivedNoticeEvents;
    const checked = filter(events, 'checked');

    return checked.length > 0 && checked.length < events.length;
  }

  handleConditionFormChange({ target }) {
    let newGoodsReceivedNotice = this.state.goodsReceivedNotice;
    newGoodsReceivedNotice.packingCondition[target.name] = parseInt(target.value);
    this.setState({ goodsReceivedNotice: newGoodsReceivedNotice });
    this.props.onSave(this.state.goodsReceivedNotice);
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
    let currentFile = 0;

    reader.onload = (upload) => {
      const file = files[currentFile];
      let grn = self.state.goodsReceivedNotice;
      grn.packingLists = grn.packingLists || [];
      grn.packingLists.push({
        list: upload.target.result,
        list_file_name: file.name,
      });
      self.state.packingFileNames.push(file.name);
      self.setState({ goodsReceivedNotice: grn, packingFileNames: self.state.packingFileNames });
      currentFile++;
      if (files[currentFile]) {
        reader.readAsDataURL(files[currentFile]);
      }
    };
    reader.readAsDataURL(files[0]);
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
