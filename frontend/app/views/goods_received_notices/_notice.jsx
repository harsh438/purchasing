import React from 'react';

export default class GoodsReceivedNoticesNotice extends React.Component {
  render() {
    return (
      <a href="#edit"
         className={this.containerClass()}
         onClick={this.handleClick.bind(this)}>
        <span>
          GRN #{this.props.id}
          <br />
          {this.props.vendorName || ''}
        </span>

        <span className="grn_notice__badge_group">
          <span className={this.badgeClass()} title="Units">{this.props.units} U</span>
          <span className={this.badgeClass()} title="Cartons">{this.props.cartons} C</span>
          <span className={this.badgeClass()} title="Pallets">{this.props.pallets} P</span>
        </span>
      </a>
    );
  }

  containerClass() {
    let classes = `grn_notice list-group-item`;

    if (this.props.compact) {
      classes += ' grn_notice--compact';
    }

    if (this.props.id === this.props.currentGoodsReceivedNotice.id) {
      classes += ' list-group-item-info';
    } else {
      classes += ` ${this.statusClass()}`;
    }

    return classes;
  }

  badgeClass() {
    return "grn_notice__badge badge";
  }

  statusClass() {
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
