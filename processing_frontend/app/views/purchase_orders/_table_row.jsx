import React from 'react';
import EditRowQuantity from '../edit_row/_quantity';
import EditRowCost from '../edit_row/_cost';
import { Popover, OverlayTrigger } from 'react-bootstrap';

export default class PurchaseOrderRow extends React.Component {
  render() {
    return (
      <tr className={this.classes()} ref="row">
        <td className="narrow">
          <input type="checkbox"
                 name="selected"
                 ref="selected"
                 checked={this.props.checked}
                 onChange={this.props.onChange.bind(this)}
                 value={this.props.purchaseOrder.id}
                 style={{ margin: '7px auto 0', display: 'block' }} />
        </td>

        <td style={{ borderLeft: '2px solid #ddd' }}>
          {this.props.purchaseOrder.poNumber}
        </td>

        <td style={{ borderLeft: '2px solid #ddd' }}>
          <a href={this.stockBugUrl()} target="_blank">
            {this.props.purchaseOrder.productId}
          </a>
        </td>
        <td className="x-wide">{this.props.purchaseOrder.productName}</td>
        <td className="wideish">{this.props.purchaseOrder.productSku}</td>
        <td>{this.props.purchaseOrder.internalSku}</td>
        <td>
          <EditRowCost displayValue={this.props.purchaseOrder.productCost}
                       ident={this.props.purchaseOrder.orderId}
                       table={this.props.table}
                       value={this.props.purchaseOrder.productCost.replace(/[^\d.-]/g, '')} />
        </td>

        <td>{this.props.purchaseOrder.productRrp}</td>
        <td className="narrowish">{this.props.purchaseOrder.productSize} {this.renderBrandSizeString(this.props.purchaseOrder.brandSize)}</td>
        <td>{this.renderCommentPopover(this.props.purchaseOrder.comment)}</td>
        <td>{this.props.purchaseOrder.gender}</td>

        <td className="wideish" style={{ borderLeft: '2px solid #ddd' }}>
          {this.props.purchaseOrder.orderType}
        </td>

        <td>{this.props.purchaseOrder.deliveryDate}</td>
        <td className="narrowish">
          <EditRowQuantity displayValue={this.props.purchaseOrder.orderedQuantity}
                           ident={this.props.purchaseOrder.orderId}
                           labelValue="Qty"
                           table={this.props.table}
                           value={this.props.purchaseOrder.orderedQuantity} />
        </td>
        <td>{this.props.purchaseOrder.orderedCost}</td>
        <td>{this.props.purchaseOrder.orderedValue}</td>

        <td className="wideish" style={{ borderLeft: '2px solid #ddd' }}>
          {this.renderArrivedDate()}
        </td>
        <td>{this.props.purchaseOrder.dropNumber}</td>
        <td className="narrowish">{this.props.purchaseOrder.deliveredQuantity}</td>
        <td>{this.props.purchaseOrder.deliveredCost}</td>
        <td>{this.props.purchaseOrder.deliveredValue}</td>

        <td className="narrowish" style={{ borderLeft: '2px solid #ddd' }}>
          {this.props.purchaseOrder.cancelledQuantity}
        </td>
        <td className="narrowish">{this.props.purchaseOrder.cancelledCost}</td>
        <td className="narrowish">{this.props.purchaseOrder.cancelledValue}</td>

        <td className="narrowish" style={{ borderLeft: '2px solid #ddd' }}>
          {this.props.purchaseOrder.balanceQuantity}
        </td>
        <td>{this.props.purchaseOrder.balanceCost}</td>
        <td className="wideish">{this.props.purchaseOrder.balanceValue}</td>
      </tr>
    );
  }

  renderCommentPopover() {
    if (this.props.purchaseOrder.comment == null || this.props.purchaseOrder.comment.length == 0) {
      return (<span />);
    }

    return (
      <OverlayTrigger id={`comment-${this.props.purchaseOrder.id}`}
                      trigger="click"
                      ref="overlayTrigger"
                      rootClose
                      placement="left"
                      overlay={this.popOverlay()}>
        <a style={{ cursor: 'pointer' }}>View</a>
      </OverlayTrigger>
    );
  }

  renderArrivedDate() {
    let date = this.props.purchaseOrder.arrivedDate

    if (date == '0') {
      return ``
    }

    return this.props.purchaseOrder.arrivedDate
  }

  popOverlay() {
    return (
      <Popover id={`comment-${this.props.purchaseOrder.id}-note`}>
        {this.props.purchaseOrder.comment}
      </Popover>
    );
  }

  renderBrandSizeString(size) {
    if (size == null || size.length == 0) {
      return ``;
    }

    return `(${size})`;
  }

  classes() {
    let classes = 'scaled';

    if (this.props.alt) {
      classes += ' active';
    }

    if (this.props.purchaseOrder.status == 'cancelled') {
      classes += ' danger';
    }

    return classes;
  }

  changeBalanceQuantityUrl() {
    return ENV['QUANTITY_EDIT_PATH']
      .replace(':pid', this.props.purchaseOrder.productId)
      .replace(':date', this.props.purchaseOrder.deliveryDate);
  }

  stockBugUrl() {
    return ENV['STOCKBUG_PATH']
      .replace(':pid', this.props.purchaseOrder.productId);
  }
}
