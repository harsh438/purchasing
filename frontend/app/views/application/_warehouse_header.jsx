import React from 'react';
import { Link } from 'react-router';
import HeaderLink from './_header_link';

export default class Header extends React.Component {
  render() {
    return (
      <div className="container-fluid">
        <nav className="navbar navbar-inverse navbar-fixed-top">
          <div className="container-fluid">
            <div className="navbar-header">
              <Link to="/warehouse"
                    className="navbar-brand"
                    style={{ paddingTop: '.6em' }}>
                <img src="/assets/images/surfdome-logo-white-500px.png"
                     alt="Surfdome"
                     style={{ height: '30px' }} />
              </Link>
            </div>

            <ul className="nav navbar-nav">
              <HeaderLink to="/warehouse/packing-lists" text="Packing lists" { ...this.props } />
              <HeaderLink to="/warehouse/goods-received-notices" text="Booking tool" { ...this.props } />
              <HeaderLink to="/warehouse/refused-deliveries" text="Refused Deliveries" { ...this.props } />
            </ul>
          </div>
        </nav>
      </div>
    );
  }
}
