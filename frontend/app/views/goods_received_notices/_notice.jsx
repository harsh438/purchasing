import React from 'react';

export default class GoodsReceivedNoticesNotice extends React.Component {
  render() {
    return (
      <a href="#edit" className={this.groupItemClass()}>
        GRN #{this.props.id}

        <span className={this.badgeClass()} title="Pallets">{this.props.pallets}</span>
        <span className={this.badgeClass()} title="Cartons">{this.props.cartons}</span>
        <span className={this.badgeClass()} title="Units">{this.props.units}</span>
      </a>
    );
  }

  groupItemClass() {
    return `grn_notice list-group-item ${this.statusClass()}`;
  }

  badgeClass() {
    return "grn_notice__badge badge";
  }

  statusClass(prefix) {
    switch (this.props.status) {
    case 'late':
      return 'grn_notice--late list-group-item-danger';
    case 'delivered':
      return 'grn_notice--delivered';
    default:
      return '';
    }
  }
}
