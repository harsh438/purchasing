import React from 'react';
import GoodsReceivedNoticesNotice from './_notice';

export default class GoodsReceivedNoticesDay extends React.Component {
  render() {
    return (
      <div className="grn_day">
        <div className="list-group">
          <div className="list-group-item">
            <span className="grn_day__title">12th Dec</span>

            <span className="badge grn_day__badge" title="Pallets">{6}</span>
            <span className="badge grn_day__badge" title="Cartons">{9}</span>
            <span className="badge grn_day__badge" title="Units">{9}</span>
          </div>

          <GoodsReceivedNoticesNotice id="1" units="3" cartons="3" pallets="2" />
          <GoodsReceivedNoticesNotice id="1" units="3" cartons="3" pallets="2" />
          <GoodsReceivedNoticesNotice id="1" units="3" cartons="3" pallets="2" />
        </div>
      </div>
    );
  }
}
