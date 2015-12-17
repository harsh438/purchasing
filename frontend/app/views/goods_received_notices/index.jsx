import React from 'react';
import { connect } from 'react-redux';
import { assign, map } from 'lodash';
import GoodsReceivedNoticesWeek from './_week';
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
        <div className="row" style={{ marginBottom: '20px' }}>
          <div className="col-md-4">
            <h1>Goods Received Notices</h1>
          </div>

          <div className="col-md-3 col-md-offset-5">
          </div>
        </div>

        {this.renderNavigation()}
        {this.renderWeekTabs()}

        <div className="row">
          <div className={leftClass}>
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
          <button className="btn btn-default"
                  style={{ width: '100%' }}>
            <span className="glyphicon glyphicon-time"></span>
            &nbsp;Now
          </button>
        </div>

        <div className="col-md-2">
          <select className="form-control">
            <option>December 2015</option>
          </select>
        </div>

        <div className="col-md-3 col-md-offset-6">
          <div className="input-group">
            <input type="text"
                   className="form-control"
                   placeholder="GRN #" />
            <span className="input-group-btn">
              <button className="btn btn-primary"
                      onClick={this.handleToggleEditing.bind(this)}>
                Find
              </button>
            </span>
          </div>
        </div>
      </div>
    );
  }

  renderWeekTabs() {
    const weeks = [{ weekNum: this.weekNum() - 2,
                     units: 10,
                     cartons: 10,
                     pallets: 2 },
                   { weekNum: this.weekNum() - 1,
                     units: 10,
                     cartons: 10,
                     pallets: 2 },
                   { weekNum: this.weekNum(),
                     units: 10,
                     cartons: 10,
                     pallets: 2,
                     class: 'active' },
                   { weekNum: this.weekNum() + 1,
                     units: 10,
                     cartons: 10,
                     pallets: 2 },
                   { weekNum: this.weekNum() + 2,
                     units: 10,
                     cartons: 10,
                     pallets: 2 }];

    return (
      <div className="row"
           style={{ marginBottom: '20px' }}>
        <div className="col-md-12">
          <ul className="nav nav-tabs nav-justified">
            {map(weeks, this.renderWeekTab, this)}
          </ul>
        </div>
      </div>
    );
  }

  renderWeekTab(week, i) {
    return (
      <li className={week.class}>
        <a href="#" className="grn_week__summary text-center">
          <h2 className="h4">Week #{week.weekNum}</h2>

          <span className="badge grn_week__badge" title="Units">{week.units}</span>
          <span className="badge grn_week__badge" title="Cartons">{week.cartons}</span>
          <span className="badge grn_week__badge" title="Pallets">{week.pallets}</span>
        </a>
      </li>
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
        <GoodsReceivedNoticesEdit onClose={this.handleToggleEditing.bind(this)} />
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
