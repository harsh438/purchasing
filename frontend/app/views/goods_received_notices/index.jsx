import React from 'react';
import { connect } from 'react-redux';
import { Link } from 'react-router';
import { assign, map } from 'lodash';
import GoodsReceivedNoticesWeek from './_week';
import GoodsReceivedNoticesEdit from './_edit';
import { loadGoodsReceivedNotices } from '../../actions/goods_received_notices';
import moment from 'moment';
import { renderSelectOptions } from '../../utilities/dom';

class GoodsReceivedNoticesIndex extends React.Component {
  componentWillMount() {
    this.state = { currentDate: new Date(),
                   editing: false,
                   startDateMonth: this.startDateMonth(),
                   startDateYear: this.startDateYear(),
                 };
    this.loadCurrentDate();
  }

  componentWillReceiveProps(nextProps) {
    const now = moment();
    let startDate = moment(nextProps.location.query.startDate, 'DD/MM/YYYY');
    if (!(startDate.isValid())) {
      startDate = moment();
    }
    startDate = startDate.format('DD/MM/YYYY');
    if (moment(this.state.currentDate).format('DD/MM/YYYY') !== startDate) {
      let date = moment(startDate, 'DD/MM/YYYY').toDate();
      this.setState({ editing: false, currentDate: date });
      this.loadCurrentDate(date);
    }
  }

  loadCurrentDate(date = this.state.currentDate) {
    const dateFormat = moment(date).format('DD/MM/YYYY');
    this.props.dispatch(loadGoodsReceivedNotices(dateFormat));
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
            {this.renderWeek()}
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
          {this.renderNowButton()}
        </div>

        <div className="col-md-3">
          <select className="form-control pull-left"
                  name="startDateMonth"
                  style={{ width: '49%', marginRight: '1%' }}
                  value={this.state.startDateMonth}
                  onChange={this.handleFormChange.bind(this)}>
            {renderSelectOptions(moment.months().map(
              function (month, index) {
                index = index + 1;
                return { name: month, id: (index < 9) ? `0${index}` : index };
              }))
            }
          </select>

          <select className="form-control pull-left"
                  name="startDateYear"
                  style={{ width: '29%', marginRight: '1%' }}
                  value={this.state.startDateYear}
                  onChange={this.handleFormChange.bind(this)}>
            {renderSelectOptions([2012, 2013, 2014, 2015, 2016, 2017, 2018])}
          </select>

          <button className="btn btn-success pull-left"
                  style={{ width: '15%' }}
                  disabled={this.monthAndYearMatches()}
                  onClick={this.handleFilter.bind(this)}>
            Go
          </button>
        </div>

        <div className="col-md-3 col-md-offset-5">
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

  renderNowButton() {
    if (this.isNow()) {
      return (
        <button className="btn btn-default"
                style={{ width: '100%' }}
                disabled
                title="This is now :)">
          <span className="glyphicon glyphicon-time"></span>
          &nbsp;Now
        </button>
      );
    } else {
      return (
        <Link to="/goods-received-notices"
              className="btn btn-default"
              style={{ width: '100%' }}
              disabled={this.isNow()}>
          <span className="glyphicon glyphicon-time"></span>
          &nbsp;Now
        </Link>
      );
    }
  }

  renderWeekTabs() {
    return (
      <div className="row"
           style={{ marginBottom: '20px' }}>
        <div className="col-md-12">
          <ul className="nav nav-tabs nav-justified">
            {map(this.props.noticeWeeks, this.renderWeekTab, this)}
          </ul>
        </div>
      </div>
    );
  }

  renderWeekTab(week, i) {
    let className = '';
    if (i === 2) className += 'active';

    return (
      <li className={className} key={week.start}>
        <Link to={`/goods-received-notices?startDate=${week.start}`}
              className="grn_week__summary text-center">
          <h2 className="h4">Week #{week.weekNum}</h2>

          <p>
            {week.start} – {week.end}
          </p>

          <span className="badge grn_week__badge" title="Units">{week.units}</span>
          <span className="badge grn_week__badge" title="Cartons">{week.cartons}</span>
          <span className="badge grn_week__badge" title="Pallets">{week.pallets}</span>
        </Link>
      </li>
    );
  }

  renderWeek() {
    const noticesByDates = this.props.noticeWeeks[2];

    return (
      <GoodsReceivedNoticesWeek compact={this.state.editing}
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

  handleFormChange({ target }) {
    this.setState({ [target.name]: target.value });
  }

  handleFilter() {
    const nextDate = `01/${this.state.startDateMonth}/${this.state.startDateYear}`;
    this.props.history.pushState(null, this.props.route.path, { startDate: nextDate });
  }

  startDate() {
    let date = new Date();
    if (this.state && this.state.currentDate) {
      date = this.state.currentDate;
    }
    return moment(date).format('DD/MM/YYYY');
  }

  startDateMonth() {
    return moment(this.startDate(), 'DD/MM/YYYY').format('MM');
  }

  startDateYear() {
    return moment(this.startDate(), 'DD/MM/YYYY').year();
  }

  now() {
    return moment().startOf('isoweek').format('DD/MM/YYYY');
  }

  isNow() {
    return this.startDate() === this.now();
  }

  monthAndYearMatches() {
    return this.startDateMonth() === this.state.startDateMonth && this.startDateYear() === this.state.startDateYear;
  }
}

function applyState({ goodsReceivedNotices }) {
  return assign({}, goodsReceivedNotices);
}

export default connect(applyState)(GoodsReceivedNoticesIndex);
