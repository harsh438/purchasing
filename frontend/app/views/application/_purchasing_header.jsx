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
              <Link to="/"
                    className="navbar-brand"
                    style={{ paddingTop: '.6em' }}>
                <img src="/assets/images/surfdome-logo-white-500px.png"
                     alt="Surfdome"
                     style={{ height: '30px' }} />
              </Link>
            </div>

            <ul className="nav navbar-nav">
              <HeaderLink to="/skus" text="SKUs" { ...this.props } />
              <HeaderLink to="/barcodes" text="Barcodes" { ...this.props } />
              <HeaderLink to="/orders" text="Orders" { ...this.props } />
              <HeaderLink to="/" text="Lines" { ...this.props } />
              <HeaderLink to="/suppliers" text="Suppliers" { ...this.props } />
              <HeaderLink to="/vendors" text="Brands" { ...this.props } />
              <HeaderLink to="/terms" text="Terms" { ...this.props } />
              <HeaderLink to="/goods-received-notices" text="Booking tool" { ...this.props } />
            </ul>
          </div>
        </nav>
      </div>
    );
  }
}
