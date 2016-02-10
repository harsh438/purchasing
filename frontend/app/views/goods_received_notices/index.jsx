import React from 'react';
import NotificationSystem from 'react-notification-system';
import { connect } from 'react-redux';
import { Link } from 'react-router';
import { assign, map } from 'lodash';
import GoodsReceivedNoticesWeek from './_week';
import GoodsReceivedNoticesEdit from './_edit';
import GoodsReceivedNoticesFind from './_find';

import { loadGoodsReceivedNotice,
         loadGoodsReceivedNotices,
         createGoodsReceivedNotice,
         clearGoodsReceivedNotice,
         saveGoodsReceivedNotice,
         addPurchaseOrderToGoodsReceivedNotice,
         removePurchaseOrderFromGoodsReceivedNotice,
         deleteGoodsReceivedNotice,
         deleteGoodsReceivedNoticePackingList } from '../../actions/goods_received_notices';

import { loadVendors } from '../../actions/filters';
import { loadPurchaseOrderList } from '../../actions/purchase_orders';

import moment from 'moment';
import { renderSelectOptions } from '../../utilities/dom';
import Qs from 'qs';

class GoodsReceivedNoticesIndex extends React.Component {
  componentWillMount() {
    this.state = { currentDate: moment().format('DD/MM/YYYY'),
                   editing: false };

    this.state.startDateMonth = this.startDateMonth();
    this.state.startDateYear = this.startDateYear();

    this.loadCurrentDate();
    this.props.dispatch(loadVendors());
  }

  componentWillReceiveProps(nextProps) {
    if (this.updateSwitchWeek(nextProps)) {
      return ;
    }

    this.updateCurrentDate(nextProps.location.query);

    const currentNotify = this.props.notification || {};
    const nextNotify = nextProps.notification || {};

    if (currentNotify.date !== nextNotify.date) {
      this.refs.notificationSystem.addNotification({ message: nextProps.notification.text, level: nextProps.notification.type });
    }
  }

  render() {
    let leftClass, rightClass;

    if (this.props.goodsReceivedNotice) {
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
            <h1>Booking tool</h1>
          </div>
        </div>

        {this.renderNavigation()}

        <div className="row">
          <div className={leftClass}>
            {this.renderWeekTabs()}
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
        <NotificationSystem ref="notificationSystem" />
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
                return { name: month, id: (index < 10) ? `0${index}` : index };
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

          <button className="btn btn-primary pull-left"
                  style={{ width: '15%' }}
                  disabled={this.monthAndYearMatches()}
                  onClick={this.handleFilter.bind(this)}>
            Go
          </button>
        </div>

        <div className="col-md-3">
          <div className="btn-group" role="group">
            <a href={this.exportMonthUrl()}
               className="btn btn-default"
               target="_blank">
              <span className="glyphicon glyphicon-cloud-download" aria-hidden="true"></span>
              &nbsp;Month
            </a>
            <a href={this.exportCurrentUrl()}
               className="btn btn-default"
               target="_blank">
              <span className="glyphicon glyphicon-cloud-download" aria-hidden="true"></span>
              &nbsp;Current
            </a>
            <a href={this.exportForcastUrl()}
               className="btn btn-default"
               target="_blank">
              <span className="glyphicon glyphicon-cloud-download" aria-hidden="true"></span>
              &nbsp;Forecast
            </a>
          </div>
        </div>

        <div className="col-md-3 col-md-offset-2">
          <GoodsReceivedNoticesFind onSearch={this.handleSearch.bind(this)}
                                    goodsReceivedNotice={this.props.goodsReceivedNotice} />
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

          <span className="badge grn_week__badge" title="Units">{week.units} U</span>
          <span className="badge grn_week__badge" title="Cartons">{week.cartons} C</span>
          <span className="badge grn_week__badge" title="Pallets">{week.pallets} P</span>
        </Link>
      </li>
    );
  }

  renderWeek() {
    const noticesByDates = this.props.noticeWeeks[2];
    return (
      <GoodsReceivedNoticesWeek compact={this.props.goodsReceivedNotice}
                                currentGoodsReceivedNotice={this.props.goodsReceivedNotice || {}}
                                onGoodsReceivedNoticeAdd={this.handleGoodsReceivedNoticeAdd.bind(this)}
                                onGoodsReceivedNoticeEdit={this.handleGoodsReceivedNoticeEdit.bind(this)}
                                {...noticesByDates} />
    );
  }

  renderEditPanel() {
    if (this.props.goodsReceivedNotice) {
      return (
        <GoodsReceivedNoticesEdit advanced={this.props.advanced}
                                  goodsReceivedNotice={this.props.goodsReceivedNotice}
                                  vendors={this.props.brands}
                                  purchaseOrders={this.props.purchaseOrders}
                                  onVendorChange={this.handleLoadPurchaseOrdersForEdit.bind(this)}
                                  onSave={this.handleGoodsReceivedNoticeSave.bind(this)}
                                  onDelete={this.handleGoodsReceivedNoticeDelete.bind(this)}
                                  onDeletePackingList={this.handleGoodsReceivedNoticeDeletePackingList.bind(this)}
                                  onPurchaseOrderAdd={this.handleAddPurchaseOrderToGoodsReceivedNotice.bind(this)}
                                  onPurchaseOrderDelete={this.handleDeletePurchaseOrderFromGoodsReceivedNotice.bind(this)}
                                  onClose={this.handleGoodsReceivedNoticeClose.bind(this)} />
      );
    }
  }

  loadCurrentDate(date = this.state.currentDate) {
    this.props.dispatch(loadGoodsReceivedNotices(date));
  }

  updateSwitchWeek(nextProps) {
    const nextGrn = nextProps.goodsReceivedNotice;
    const curGrn = this.props.goodsReceivedNotice;
    const queryStartDate = nextProps.location.query.startDate;
    const startDate =  queryStartDate ? moment(queryStartDate, 'DD/MM/YYYY') : moment();
    if (curGrn
        && nextGrn
        && nextGrn.id !== curGrn.id
        && nextGrn.deliveryDate
        && moment(nextGrn.deliveryDate, 'DD/MM/YYYY').week() !== startDate.week()
      ) {
      this.props.history.pushState(null, this.props.route.path, { startDate: nextGrn.deliveryDate });
      return true;
    }
    return false;
  }

  updateCurrentDate(query) {
    const startDate = query.startDate ? moment(query.startDate, 'DD/MM/YYYY') : moment();
    const startDateFormatted = startDate.format('DD/MM/YYYY');

    if (this.state.currentDate !== startDateFormatted) {
      const nextState = { editing: false,
                          currentDate: startDateFormatted,
                          startDateMonth: startDate.format('MM'),
                          startDateYear: startDate.format('YYYY') };

      this.setState(nextState, this.loadCurrentDate.bind(this));
    }
  }

  handleGoodsReceivedNoticeClose() {
    this.props.dispatch(clearGoodsReceivedNotice());
  }

  handleSearch(grnId) {
    this.props.dispatch(loadGoodsReceivedNotice(grnId));
  }

  handleGoodsReceivedNoticeAdd(deliveryDate) {
    this.props.dispatch(createGoodsReceivedNotice({ deliveryDate, currentDate: this.state.currentDate }));
  }

  handleGoodsReceivedNoticeEdit(grnId) {
    this.props.dispatch(loadGoodsReceivedNotice(grnId));
  }

  handleGoodsReceivedNoticeSave(grn) {
    this.props.dispatch(saveGoodsReceivedNotice({ ...grn, currentDate: this.state.currentDate }));
  }

  handleGoodsReceivedNoticeDelete(id) {
    this.props.dispatch(deleteGoodsReceivedNotice({ id, currentDate: this.state.currentDate }));
  }

  handleGoodsReceivedNoticeDeletePackingList({ goodsReceivedNotice, packingListUrl }) {
    if (confirm('Are you sure to delete this packing list ?')) {
      this.props.dispatch(deleteGoodsReceivedNoticePackingList({ id: goodsReceivedNotice.id, packingListUrl }));
    }
  }

  handleAddPurchaseOrderToGoodsReceivedNotice(grn) {
    this.props.dispatch(addPurchaseOrderToGoodsReceivedNotice({ ...grn, currentDate: this.state.currentDate }));
  }

  handleDeletePurchaseOrderFromGoodsReceivedNotice(goodsReceivedNoticeEventId) {
    this.props.dispatch(removePurchaseOrderFromGoodsReceivedNotice({ id: this.props.goodsReceivedNotice.id,
                                                                     currentDate: this.state.currentDate,
                                                                     goodsReceivedNoticeEventId }));
  }

  handleLoadPurchaseOrdersForEdit(vendorId) {
    this.props.dispatch(loadPurchaseOrderList({ vendorId }));
  }

  handleFormChange({ target }) {
    this.setState({ [target.name]: target.value });
  }

  handleFilter() {
    const nextDate = `01/${this.state.startDateMonth}/${this.state.startDateYear}`;
    this.props.history.pushState(null, this.props.route.path, { startDate: nextDate });
  }

  startDateMonth() {
    return moment(this.state.currentDate, 'DD/MM/YYYY').format('MM');
  }

  startDateYear() {
    return moment(this.state.currentDate, 'DD/MM/YYYY').year();
  }

  now() {
    return moment().startOf('isoweek').format('DD/MM/YYYY');
  }

  isNow() {
    return this.state.currentDate === this.now();
  }

  monthAndYearMatches() {
    return this.startDateMonth() === this.state.startDateMonth && this.startDateYear() === this.state.startDateYear;
  }

  exportMonthUrl() {
    const query = Qs.stringify({ month: this.state.startDateMonth,
                                 year: this.state.startDateYear,
                                 type: 'month' });
    return '/api/goods_received_notices.xlsx?' + query;
  }

  exportCurrentUrl() {
    const startDate = moment(this.state.currentDate, 'DD/MM/YYYY').subtract(2, 'weeks').format('YYYY-MM-DD');
    const endDate = moment(this.state.currentDate, 'DD/MM/YYYY').add({ weeks: 2 }).format('YYYY-MM-DD');
    const query = Qs.stringify({ start_date: startDate,
                                 end_date: endDate,
                                 type: 'range' });
    return '/api/goods_received_notices.xlsx?' + query;
  }

  exportForcastUrl() {
    const startDate = moment(this.state.currentDate, 'DD/MM/YYYY').subtract(2, 'weeks').format('YYYY-MM-DD');
    const endDate = moment(this.state.currentDate, 'DD/MM/YYYY').add({ months: 2, weeks: 2 }).format('YYYY-MM-DD');
    const query = Qs.stringify({ start_date: startDate,
                                 end_date: endDate,
                                 type: 'range' });
    return '/api/goods_received_notices.xlsx?' + query;
  }
}

function applyState({ filters,
                      goodsReceivedNotices,
                      purchaseOrders,
                      notification,
                      advanced }) {
  return assign({ advanced }, filters, goodsReceivedNotices, purchaseOrders, notification);
}

export default connect(applyState)(GoodsReceivedNoticesIndex);
