import React from 'react';
import GoodsReceivedNoticesDay from './_day';
import { map } from 'lodash';

export default class GoodsReceivedNoticesWeek extends React.Component {
  render() {
    return (
      <div className="grn_week row">
        <div className="grn_week__summary text-right">
          <h2 className="h4">Week #{this.props.weekNum}</h2>

          <span className="badge grn_week__badge" title="Units">{75}</span>
          <span className="badge grn_week__badge" title="Cartons">{15}</span>
          <span className="badge grn_week__badge" title="Pallets">{15}</span>
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
      <GoodsReceivedNoticesDay key={date} {...noticesForDate} />
    );
  }
}
