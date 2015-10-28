import React, { Component } from 'react';
import { RouteHandler } from 'react-router';

export default class Layout extends Component {
  render () {
    return (
      <div className="app">
        {this.props.children}
      </div>
    );
  }
}
