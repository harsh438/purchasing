import React from 'react';
import Header from '../application/_purchasing_header';

export default class PurchasingLayout extends React.Component {
  render () {
    return (
      <div className="purchase_processing_app">
        <Header currentPath={this.props.location.pathname} />
        {this.props.children}
      </div>
    );
  }
}
