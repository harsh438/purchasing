import React from 'react';
import { RouteHandler } from 'react-router';

export default class Application extends React.Component {
  render () {
    return (
      <div className="app">
        {this.props.children}
      </div>
    );
  }
}
