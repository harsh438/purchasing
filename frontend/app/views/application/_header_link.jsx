import React from 'react';
import { Link } from 'react-router';
import { startsWith } from 'lodash';

export default class HeaderLink extends React.Component {
  render() {
    return (
      <li className={this.className()}>
        <Link to={this.props.to}>{this.props.text}</Link>
      </li>
    );
  }

  className() {
    if (this.props.to === '/') {
      if (this.props.currentPath === '/') return 'active';
    } else if (startsWith(this.props.currentPath, this.props.to)) {
      return 'active';
    }
  }
}
