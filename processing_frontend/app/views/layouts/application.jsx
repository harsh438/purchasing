import React from 'react';
import { RouteHandler } from 'react-router';
import Header from '../application/_header';

export default class Application extends React.Component {
  render () {
    return (
      <div className="purchase_processing_app">
        <Header />
        <div style={{ marginTop: '80px' }}>
          {this.props.children}
        </div>
      </div>
    );
  }
}
