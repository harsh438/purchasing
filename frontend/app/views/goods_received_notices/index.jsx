import React from 'react';
import { connect } from 'react-redux';
import { assign } from 'lodash';
import GoodsReceivedNoticesWeek from './_week';
import GoodsReceivedNoticesDayHeading from './_day_heading';

class GoodsReceivedNoticesIndex extends React.Component {
  render() {
    return (
      <div className="suppliers_index  container-fluid"
           style={{ marginTop: '70px' }}>
        {this.renderDayHeadings()}
        {this.renderWeeks()}
      </div>
    );
  }

  renderDayHeadings() {
    return (
      <div className="row">
        <GoodsReceivedNoticesDayHeading key="1" day="Monday" />
        <GoodsReceivedNoticesDayHeading key="2" day="Tuesday" />
        <GoodsReceivedNoticesDayHeading key="3" day="Wednesday" />
        <GoodsReceivedNoticesDayHeading key="4" day="Thursday" />
        <GoodsReceivedNoticesDayHeading key="5" day="Friday" />
      </div>
    );
  }

  renderWeeks() {
    return [(<GoodsReceivedNoticesWeek key="1" id="1" />),
            (<GoodsReceivedNoticesWeek key="2" id="2" />)];
  }
}

function applyState({ goodsReceivedNotices }) {
  return assign({}, goodsReceivedNotices);
}

export default connect(applyState)(GoodsReceivedNoticesIndex);
