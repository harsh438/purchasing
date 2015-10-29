import React from 'react';
import { RouteHandler } from 'react-router';
import Header from '../application/_header';

export default class Application extends React.Component {
  render () {
    return (
      <div className="purchase_processing_app">
        <Header />
        {this.props.children}
      </div>
    );
  }
}
