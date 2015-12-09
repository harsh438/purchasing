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
        {this.renderNavigation()}
        {this.renderDayHeadings()}
        {this.renderWeeks()}
      </div>
    );
  }

  renderNavigation() {
    return (
      <div className="row" style={{ marginBottom: '2em' }}>
        <div className="col-md-3">
          <div className="input-group">
            <span className="input-group-addon">
              <span className="glyphicon glyphicon-calendar"></span>
            </span>

            <input type="date" className="form-control" />

            <span className="input-group-btn">
              <button className="btn btn-default">
                This week
              </button>
            </span>
          </div>
        </div>

        <div className="col-md-3 col-md-offset-6">
          <div className="input-group">
            <input type="text"
                   className="form-control"
                   placeholder="GRN #" />
            <span className="input-group-btn">
              <button className="btn btn-success">
                Find
              </button>
            </span>
          </div>
        </div>
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
    return map(this.props.noticesByWeek, this.renderWeek, this);
  }

  renderWeek(noticesByDates, weekNum) {
    return (
      <GoodsReceivedNoticesWeek key={weekNum} {...noticesByDates} />
    );
  }
}

function applyState({ goodsReceivedNotices }) {
  return assign({}, goodsReceivedNotices);
}

export default connect(applyState)(GoodsReceivedNoticesIndex);
