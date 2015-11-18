import React from 'react';
import { Link } from 'react-router';

class HeaderLink extends React.Component {
  render() {
    return (
      <li className={this.className()}>
        <Link to={this.props.to}>{this.props.text}</Link>
      </li>
    );
  }

  className() {
    return 'active';
  }
}

export default class Header extends React.Component {
  render() {
    return (
      <div className="container-fluid">
        <nav className="navbar navbar-inverse navbar-fixed-top">
          <div className="container-fluid">
            <div className="navbar-header">
              <Link to="/"
                    className="navbar-brand"
                    style={{ paddingTop: '.6em' }}>
                <img src="/assets/images/surfdome-logo-white-500px.png"
                     alt="Surfdome"
                     style={{ height: '30px'}} />
              </Link>
            </div>

            <ul className="nav navbar-nav">
              <HeaderLink to="/" text="Purchase Orders" />
            </ul>
          </div>
        </nav>
      </div>
    );
  }
}
