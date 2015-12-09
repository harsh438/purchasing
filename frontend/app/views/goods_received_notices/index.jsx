import React from 'react';
import { connect } from 'react-redux';
import { assign, map } from 'lodash';
import GoodsReceivedNoticesWeek from './_week';
import GoodsReceivedNoticesDayHeading from './_day_heading';
import { loadGoodsReceivedNotices } from '../../actions/goods_received_notices';

class GoodsReceivedNoticesIndex extends React.Component {
  componentWillMount() {
    this.props.dispatch(loadGoodsReceivedNotices());
  }

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
    return map(this.props.goodsReceivedNoticesByWeek, this.renderWeek, this);
  }

  renderWeek(goodsReceivedNoticesByDay, weekNum) {
    return (
      <GoodsReceivedNoticesWeek key={weekNum}
                                weekNum={weekNum}
                                goodsReceivedNoticesByDay={goodsReceivedNoticesByDay} />
    );
  }
}

function applyState({ goodsReceivedNotices }) {
  return assign({}, goodsReceivedNotices);
}

export default connect(applyState)(GoodsReceivedNoticesIndex);
