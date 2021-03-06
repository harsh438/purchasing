import React from 'react';
import GoodsReceivedNoticesNotice from './_notice';
import { map } from 'lodash';
import moment from 'moment';

export default class GoodsReceivedNoticesDay extends React.Component {
  render() {
    return (
      <div className={this.containerClass()}>
        <div className="panel panel-default">
          <div className="panel-heading grn_day__heading">
            <div className="grn_day__title">{this.deliveryDate()}</div>

            <span className="badge grn_day__badge" title="Units">{this.props.units} U</span>
            <span className="badge grn_day__badge" title="Cartons">{this.props.cartons} C</span>
            <span className="badge grn_day__badge" title="Pallets">{this.props.pallets} P</span>

            <a href="#add"
               className="grn_day__add_btn--before-grns btn btn-default"
               onClick={this.handleGoodsReceivedNoticeAdd.bind(this)}>
              <span className="glyphicon glyphicon-plus"></span>
            </a>
          </div>

          <div className="list-group">
            {this.renderNotices()}
          </div>
        </div>

        <div className="text-center">
          <a href="#add"
             className="grn_day__add_btn--after-grns btn btn-default"
             onClick={this.handleGoodsReceivedNoticeAdd.bind(this)}>
            <span className="glyphicon glyphicon-plus"></span>
          </a>
        </div>
      </div>
    );
  }

  renderNotices() {
    return map(this.props.notices, this.renderNotice, this);
  }

  renderNotice(notice, i) {
    return (
      <GoodsReceivedNoticesNotice key={i}
                                  currentGoodsReceivedNotice={this.props.currentGoodsReceivedNotice}
                                  compact={this.props.compact}
                                  onClick={this.props.onEditGoodsReceivedNotice}
                                  {...notice} />
    );
  }

  containerClass() {
    if (this.props.compact) {
      return 'grn_day grn_day--compact';
    } else {
      return 'grn_day';
    }
  }

  deliveryDate() {
    return moment(this.props.deliveryDate, 'DD/MM/YYYY').format('ddd, Do MMM');
  }

  handleGoodsReceivedNoticeAdd(e) {
    e.preventDefault();
    this.props.onGoodsReceivedNoticeAdd(this.props.deliveryDate);
  }
}
