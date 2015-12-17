import React from 'react';

export default class GoodsReceivedNoticesNotice extends React.Component {
  render() {
    return (
      <a href="#edit"
         className={this.containerClass()}
         onClick={this.handleClick.bind(this)}>
        GRN #{this.props.id} - {this.props.vendorName}

        <span className={this.badgeClass()} title="Pallets">{this.props.pallets}</span>
        <span className={this.badgeClass()} title="Cartons">{this.props.cartons}</span>
        <span className={this.badgeClass()} title="Units">{this.props.units}</span>
      </a>
    );
  }

  containerClass() {
    let classes = `grn_notice list-group-item ${this.statusClass()}`;
    if (this.props.compact) classes += ' grn_notice--compact';
    return classes;
  }

  badgeClass() {
    return "grn_notice__badge badge";
  }

  statusClass(prefix) {
    switch (this.props.status) {
    case 'late':
      return 'grn_notice--late list-group-item-danger';
    case 'delivered':
      return 'grn_notice--delivered list-group-item-warning';
    case 'received':
      return 'grn_notice--received list-group-item-success';
    default:
      return '';
    }
  }

  handleClick(e) {
    e.preventDefault();
    this.props.onClick(this.props.id);
  }
}
