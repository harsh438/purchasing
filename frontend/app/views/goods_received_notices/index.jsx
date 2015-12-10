import React from 'react';
import { connect } from 'react-redux';
import { assign, map } from 'lodash';
import GoodsReceivedNoticesWeek from './_week';
import GoodsReceivedNoticesDayHeading from './_day_heading';
import GoodsReceivedNoticesEdit from './_edit';
import { loadGoodsReceivedNotices } from '../../actions/goods_received_notices';
import moment from 'moment';

class GoodsReceivedNoticesIndex extends React.Component {
  componentWillMount() {
    this.state = { editing: false };
    this.props.dispatch(loadGoodsReceivedNotices(this.weekNum()));
  }

  render() {
    let leftClass, rightClass;

    if (this.state.editing) {
      leftClass = 'col-md-8';
      rightClass = 'col-md-4';
    } else {
      leftClass = 'col-md-12';
      rightClass = '';
    }

    return (
      <div className="suppliers_index container-fluid"
           style={{ marginTop: '70px' }}>
        {this.renderNavigation()}

        <div className="row">
          <div className={leftClass}>
            {this.renderDayHeadings()}
            {this.renderWeeks()}
          </div>

          <div className={rightClass}>
            {this.renderEditPanel()}
          </div>
        </div>
      </div>
    );
  }

  renderNavigation() {
    return (
      <div className="row" style={{ marginBottom: '2em' }}>
        <div className="col-md-1">
          <button className="btn btn-default">
            This week
          </button>
        </div>

        <div className="col-md-4 col-md-offset-3">
          <div className="input-group">
            <span className="input-group-btn">
              <button className="btn btn-default">
                &nbsp;<span className="glyphicon glyphicon-fast-backward"></span>&nbsp;
              </button>

              <button className="btn btn-default">
                &nbsp;<span className="glyphicon glyphicon-backward"></span>&nbsp;
              </button>
            </span>

            <input type="date"
                   className="form-control text-center" />

            <span className="input-group-btn">
              <button className="btn btn-default">
                &nbsp;<span className="glyphicon glyphicon-forward"></span>&nbsp;
              </button>

              <button className="btn btn-default">
                &nbsp;<span className="glyphicon glyphicon-fast-forward"></span>&nbsp;
              </button>
            </span>
          </div>

          <div className="grn_week__summary text-center">
            <h2 className="h4">Week #{this.weekNum()}</h2>

            <span className="badge grn_week__badge" title="Units">{this.props.units}</span>
            <span className="badge grn_week__badge" title="Cartons">{this.props.cartons}</span>
            <span className="badge grn_week__badge" title="Pallets">{this.props.pallets}</span>
          </div>
        </div>

        <div className="col-md-3 col-md-offset-1">
          <div className="input-group">
            <input type="text"
                   className="form-control"
                   placeholder="GRN #" />
            <span className="input-group-btn">
              <button className="btn btn-success"
                      onClick={this.handleToggleEditing.bind(this)}>
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
        <GoodsReceivedNoticesDayHeading key="1"
                                        day="Monday"
                                        compact={this.state.editing} />
        <GoodsReceivedNoticesDayHeading key="2"
                                        day="Tuesday"
                                        compact={this.state.editing} />
        <GoodsReceivedNoticesDayHeading key="3"
                                        day="Wednesday"
                                        compact={this.state.editing} />
        <GoodsReceivedNoticesDayHeading key="4"
                                        day="Thursday"
                                        compact={this.state.editing} />
        <GoodsReceivedNoticesDayHeading key="5"
                                        day="Friday"
                                        compact={this.state.editing} />
      </div>
    );
  }

  renderWeeks() {
    return map(this.props.noticesByWeek, this.renderWeek, this);
  }

  renderWeek(noticesByDates, weekNum) {
    return (
      <GoodsReceivedNoticesWeek key={weekNum}
                                compact={this.state.editing}
                                onEditGoodsReceivedNotice={this.handleEditGoodsReceivedNotice.bind(this)}
                                {...noticesByDates} />
    );
  }

  renderEditPanel() {
    if (this.state.editing) {
      return (
        <GoodsReceivedNoticesEdit />
      );
    }
  }

  handleToggleEditing() {
    this.setState({ editing: !this.state.editing });
  }

  handleEditGoodsReceivedNotice(id) {
    this.setState({ editing: true });
  }

  weekNum() {
    return this.props.weekNum || moment().isoWeek();
  }
}

function applyState({ goodsReceivedNotices }) {
  return assign({}, goodsReceivedNotices);
}

export default connect(applyState)(GoodsReceivedNoticesIndex);
