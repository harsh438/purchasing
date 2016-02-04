import React from 'react';
import { renderSelectOptions } from '../../utilities/dom';
import { map } from 'lodash';

export default class GoodsReceivedNoticesEdit extends React.Component {
  componentWillMount() {
    this.state = { id: this.props.goodsReceivedNotice.id };
  }

  componentWillReceiveProps(nextProps) {
    this.setState({ id: nextProps.goodsReceivedNotice.id });
  }

  render() {
    return (
      <div className="grn_edit">
        <div className="panel panel-default panel-info">
          <div className="panel-heading">
            <h3 className="panel-title">
              GRN #{this.props.goodsReceivedNotice.id}
              &nbsp;–&nbsp;
              {this.props.goodsReceivedNotice.deliveryDate}
              <a style={{ cursor:'pointer' }}
                 className="pull-right glyphicon glyphicon-remove"
                 onClick={this.props.onClose}
                 aria-label="close"
                 ></a>
            </h3>
          </div>

          <div className="panel-body">
            <form onChange={this.handleChange.bind(this)}
                  onSubmit={this.handleSubmit.bind(this)}>
              <div className="form-group">
                <select className="form-control"
                        id="vendorId"
                        name="vendorId"
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
          </div>
          <ul className="nav nav-tabs">
            <li className="active"><a>Purchase Orders</a></li>
          </ul>
          <div className="tab-content">
              <div className="tabpanel">{this.renderPurchaseOrders()}</div>
          </div>
        </div>
      </div>
    );
  }

  renderPurchaseOrders() {
    if (this.props.goodsReceivedNotice.goodsReceivedNoticeEvents.length === 0) {
      return (<div style={{ margin: '15px' }}><i>No purchase orders currently.</i></div>);
    }
    return map(this.props.goodsReceivedNotice.goodsReceivedNoticeEvents, this.renderPurchaseOrder, this);
  }

  renderPurchaseOrder(goodsReceivedNoticeEvent) {
    return (
      <div className="list-group-item grn_edit__form_group--purchase_order_item" key={goodsReceivedNoticeEvent.id}>
        #{goodsReceivedNoticeEvent.purchaseOrderId}

        <div className="pull-right">
          <span className="badge" title="Units">{goodsReceivedNoticeEvent.units} U</span>&nbsp;
          <span className="badge" title="Cartons">{goodsReceivedNoticeEvent.cartons} C</span>&nbsp;
          <span className="badge" title="Pallets">{goodsReceivedNoticeEvent.pallets} P</span>&nbsp;
          <button className="btn btn-sm btn-danger"
                  style={{ marginTop: '-.4em' }}
                  onClick={this.handleDelete.bind(this, goodsReceivedNoticeEvent.id)}>Delete</button>
        </div>
      </div>
    );
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
    this.props.onSave(this.state);
  }

  handleDelete(id) {
    if (confirm('Are you sure you wish to remove this Purchase Order?')) {
      this.props.onGoodsReceivedNoticeEventDelete(id);
    }
  }
}
