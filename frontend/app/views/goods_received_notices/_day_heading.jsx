import React from 'react';

export default class GoodsReceivedNoticesDayHeading extends React.Component {
  render() {
    return (
      <div className={this.containerClass()}>
        <h2 className="h4 text-center">{this.props.day}</h2>
      </div>
    );
  }

  containerClass() {
    if (this.props.compact) {
      return 'grn_day_heading grn_day_heading--compact';
    } else {
      return 'grn_day_heading';
    }
  }
}
