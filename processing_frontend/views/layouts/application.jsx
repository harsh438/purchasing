import React, { Component } from 'react';
import { RouteHandler } from 'react-router';

export default class Application extends Component {
  render () {
    return (
      <div className="app">
        {this.props.children}
      </div>
    );
  }
}
