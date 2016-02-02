import React from 'react';
import GoodsReceivedNoticesDay from './_day';
import { map } from 'lodash';

export default class GoodsReceivedNoticesWeek extends React.Component {
  render() {
    return (
      <div className="grn_week">
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
                               onGoodsReceivedNoticeAdd={this.props.onGoodsReceivedNoticeAdd}
                               {...noticesForDate} />
    );
  }
}
