import React from 'react';
import GoodsReceivedNoticesRollup from './_rollup';

export default class GoodsReceivedNoticesNotice extends React.Component {
  render() {
    return (
      <a href="#edit" className={`grn_notice list-group-item ${this.statusClass()}`}>
        GRN #{this.props.id}

        <span className="badge grn_notice__badge" title="Pallets">{this.props.pallets}</span>
        <span className="badge grn_notice__badge" title="Cartons">{this.props.cartons}</span>
        <span className="badge grn_notice__badge" title="Units">{this.props.units}</span>
      </a>
    );
  }

  statusClass() {
    switch (this.props.status) {
    default:
      return '';
    }
  }
}
