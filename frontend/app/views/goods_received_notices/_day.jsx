import React from 'react';
import GoodsReceivedNoticesNotice from './_notice';
import { map } from 'lodash';

export default class GoodsReceivedNoticesDay extends React.Component {
  render() {
    console.log(this.props.notices);

    return (
      <div className="grn_day">
        <div className="list-group">
          <div className="list-group-item">
            <span className="grn_day__title">{this.props.deliveryDate}</span>

            <span className="badge grn_day__badge" title="Pallets">{3}</span>
            <span className="badge grn_day__badge" title="Cartons">{3}</span>
            <span className="badge grn_day__badge" title="Units">{15}</span>
          </div>

          {this.renderNotices()}
        </div>
      </div>
    );
  }

  renderNotices() {
    return map(this.props.notices, this.renderNotice, this);
  }

  renderNotice(notice) {
    return (
      <GoodsReceivedNoticesNotice {...notice} />
    );
  }
}
