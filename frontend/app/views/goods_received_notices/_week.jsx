import React from 'react';
import GoodsReceivedNoticesDay from './_day';

export default class GoodsReceivedNoticesWeek extends React.Component {
  render() {
    return (
      <div className="grn_week row">
        <div className="grn_week__summary text-right">
          <h2 className="h4">Week #{this.props.id}</h2>

          <span className="badge grn_week__badge" title="Pallets">{36}</span>
          <span className="badge grn_week__badge" title="Cartons">{45}</span>
          <span className="badge grn_week__badge" title="Units">{45}</span>
        </div>

        <GoodsReceivedNoticesDay />
        <GoodsReceivedNoticesDay />
        <GoodsReceivedNoticesDay />
        <GoodsReceivedNoticesDay />
        <GoodsReceivedNoticesDay />
      </div>
    );
  }
}
