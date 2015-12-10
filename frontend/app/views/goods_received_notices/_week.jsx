import React from 'react';
import GoodsReceivedNoticesDay from './_day';
import { map } from 'lodash';

export default class GoodsReceivedNoticesWeek extends React.Component {
  render() {
    return (
      <div className="grn_week row">
        <div className="grn_week__summary text-right">
          <h2 className="h4">Week #{this.props.weekNum}</h2>

          <span className="badge grn_week__badge" title="Units">{this.props.units}</span>
          <span className="badge grn_week__badge" title="Cartons">{this.props.cartons}</span>
          <span className="badge grn_week__badge" title="Pallets">{this.props.pallets}</span>
        </div>

        {this.renderDates()}
      </div>
    );
  }

  renderDates() {
    return map(this.props.noticesByDate, this.renderDate, this);
  }

  renderDate(noticesForDate, date) {
    return (
      <GoodsReceivedNoticesDay key={date}
                               compact={this.props.compact}
                               {...noticesForDate} />
    );
  }
}
