import React from 'react';

export default class GoodsReceivedNoticesDayHeading extends React.Component {
  render() {
    return (
      <div className="grn_day_heading">
        <h2 className="h4 text-center">{this.props.day}</h2>
      </div>
    );
  }
}
