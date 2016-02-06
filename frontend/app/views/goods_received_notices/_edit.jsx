import React from 'react';
import { renderSelectOptions } from '../../utilities/dom';
import { map } from 'lodash';
import { Nav, NavItem } from 'react-bootstrap';

export default class GoodsReceivedNoticesEdit extends React.Component {
  componentWillMount() {
    let { id, deliveryDate } = this.props.goodsReceivedNotice;
    const tab = 'purchaseOrders';
    this.state = { id, deliveryDate, tab };
  }

  componentWillReceiveProps(nextProps) {
    let { id, deliveryDate } = this.props.goodsReceivedNotice;
    deliveryDate = deliveryDate.split('/').reverse().join('-');
    this.setState({ id, deliveryDate });
  }

  render() {
    return (
      <div className="grn_edit">
        <div className="panel panel-default panel-info">
          <div className="panel-heading">
            <h3 className="panel-title">
              GRN #{this.props.goodsReceivedNotice.id}
              <span className="pull-right">
                <span className="badge" title="Units">{this.props.goodsReceivedNotice.units} U</span>&nbsp;
                <span className="badge" title="Cartons">{this.props.goodsReceivedNotice.cartons} C</span>&nbsp;
                <span className="badge" title="Pallets">{this.props.goodsReceivedNotice.pallets} P</span>&nbsp;

                <a style={{ cursor: 'pointer', marginLeft: '10px' }}
                   className="glyphicon glyphicon-remove"
                   onClick={this.props.onClose}
                   aria-label="close"
                 ></a>
              </span>
            </h3>
          </div>

          <div className="panel-body">
            <Nav bsStyle="tabs"
                 activeKey={this.state.tab}
                 onSelect={this.handleTabChange.bind(this)}
                 style={{ marginBottom: '10px' }}>
              <NavItem eventKey="purchaseOrders">Purchase orders</NavItem>
              <NavItem eventKey="packingLists">Packing lists</NavItem>
              <NavItem eventKey="advanced">Advanced</NavItem>
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
                  id="vendorId"
                  value={this.state.vendorId}
                  onChange={this.handleVendorChange.bind(this)}>
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
                    value={this.state.purchaseOrderId}>
              <option value=""> -- select purchase order -- </option>
              {renderSelectOptions(map(this.props.purchaseOrders, 'id'))}
            </select>
          </div>

          <div className="form-group grn_edit__form_group--units">
            <label htmlFor="units">Units</label>
            <input type="number" name="units" className="form-control" />
          </div>

          <div className="form-group grn_edit__form_group--cartons">
            <label htmlFor="cartons">Cartons</label>
            <input type="number" name="cartons" className="form-control" />
          </div>

          <div className="form-group grn_edit__form_group--pallets">
            <label>Palettes</label>
            <input type="number" name="pallets" className="form-control" />
          </div>

          <div className="text-right">
            <button className="btn btn-success">Add</button>
          </div>
        </div>
      </form>
    );
  }

  renderPurchaseOrders() {
    if (this.props.goodsReceivedNotice.goodsReceivedNoticeEvents.length === 0) {
      return (
        <i>No purchase orders currently.</i>
      );
    }

    return (
      <table className="table table-striped table-condensed">
        <thead>
          <tr>
            <th colSpan="2">&nbsp;</th>
          </tr>
        </thead>
        <tbody>
          {map(this.props.goodsReceivedNotice.goodsReceivedNoticeEvents, this.renderPurchaseOrder, this)}
        </tbody>
      </table>
    );
  }

  renderPurchaseOrder(goodsReceivedNoticeEvent) {
    return (
      <tr className={this.goodsReceivedNoticeEventClass(goodsReceivedNoticeEvent)}
          key={goodsReceivedNoticeEvent.id}>
        <td style={{ fontSize: '.9em', lineHeight: '2.1em' }}>
          #{goodsReceivedNoticeEvent.purchaseOrderId}
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
    const attachments = this.props.goodsReceivedNotice.attachments || '';

    return (
      <table className="table table-striped table-condensed">
        <tbody>
          {attachments.split(',').map(this.renderPackingList)}
        </tbody>
      </table>
    );
  }

  renderPackingList(packingList) {
    if (!packingList) return;
    const href = `https://www.sdometools.com/tools/bookingin_tool/attachments/${encodeURIComponent(packingList)}`;

    return (
        <tr>
          <td>
            <a target="_blank" href={href}>
              Download {packingList}
            </a>
          </td>
        </tr>
      );
  }

  renderAdvanced() {
    return (
      <div>
        <form onChange={this.handleChange.bind(this)}
              onSubmit={this.handleChangeDateSubmit.bind(this)}>
          <div className="form-group">
            <input className="form-control"
                   type="date"
                   name="deliveryDate"
                   value={this.state.deliveryDate} />
          </div>

          <div className="text-right">
            <button className="btn btn-warning">Change date</button>
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

  handleChange({ target }) {
    this.setState({ [target.name]: target.value });
  }

  handleVendorChange(e) {
    e.stopPropagation();
    this.props.onVendorChange(e.target.value);
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

  handleDeletePurchaseOrder(id) {
    if (confirm('Are you sure you wish to remove this Purchase Order?')) {
      this.props.onPurchaseOrderDelete(id);
    }
  }

  handleTabChange(tab) {
    this.setState({ tab });
  }
}
