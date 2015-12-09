import React from 'react';
import GoodsReceivedNoticesNotice from './_notice';
import { map } from 'lodash';

export default class GoodsReceivedNoticesDay extends React.Component {
  render() {
    return (
      <div className="grn_day">
        <div className="list-group">
          <div className="list-group-item">
            <span className="grn_day__title">{this.props.deliveryDate}</span>

            <span className="badge grn_day__badge" title="Pallets">{this.props.pallets}</span>
            <span className="badge grn_day__badge" title="Cartons">{this.props.cartons}</span>
            <span className="badge grn_day__badge" title="Units">{this.props.units}</span>
          </div>

          {this.renderNotices()}
        </div>

        <div className="text-center">
          <a href="#add" className="grn_day__add_btn btn btn-default">
            <span className="glyphicon glyphicon-plus"></span>
          </a>
        </div>
      </div>
    );
  }

  renderNotices() {
    return map(this.props.notices, this.renderNotice, this);
  }

  renderNotice(notice, i) {
    return (
      <GoodsReceivedNoticesNotice key={i} {...notice} />
    );
  }
}
