import React from 'react';
import { connect } from 'react-redux';
import { Link } from 'react-router';
import { Nav, NavItem } from 'react-bootstrap';
import { at, assign, compact, flatten, map } from 'lodash';
import { loadSupplier,
         editSupplier,
         saveSupplierContact,
         saveSupplierBuyer,
         saveSupplierTerms } from '../../actions/suppliers';
import { loadSeasons, loadVendors } from '../../actions/filters';
import SuppliersForm from './_form';
import SupplierContactsTable from '../supplier_contacts/_table';
import SupplierBuyersTable from '../supplier_buyers/_table';
import SupplierTermsDefault from '../supplier_terms/_default';
import SuppliersTermsTable from '../supplier_terms/_table';

class SuppliersEdit extends React.Component {
  componentWillMount () {
    this.state = { editingSupplier: false,
                   tab: { supplier: 'details',
                          terms: 'default',
                          brands: 'default',
                        } };
    this.props.dispatch(loadSupplier(this.props.params.id));
    this.props.dispatch(loadSeasons());
    this.props.dispatch(loadVendors());
  }

  componentWillReceiveProps(nextProps) {
    if (this.state.switchBrandsTab) {
      this.handleTabChange('brands', this.state.switchBrandsTab)
      this.setState({switchBrandsTab: null})
    }
  }

  render() {
    return (
      <div className="suppliers_edit container-fluid" style={{ marginTop: '70px' }}>
        <div className="row" style={{ marginBottom: '20px' }}>
          <div className="col-md-6">
            <h1>
              <Link to="/suppliers">Suppliers</Link>
              &nbsp;/&nbsp;
              {this.props.supplier.name}
            </h1>
          </div>
        </div>

        <div className="row">
          <div className="col-md-6">
            <Nav bsStyle="tabs"
                 activeKey={this.state.tab.supplier}
                 onSelect={this.handleTabChange.bind(this, 'supplier')}
                 style={{ marginBottom: '10px' }}>
              <NavItem eventKey="details">Details</NavItem>
              <NavItem eventKey="contacts">Contacts</NavItem>
              <NavItem eventKey="buyers">Buyers</NavItem>
            </Nav>

            {this.renderSupplierTab()}
          </div>

          {this.renderBrandsNav()}

          <div className="col-md-6">
            {this.renderDefaultHistoryTab()}

            {this.renderTermsTab()}
          </div>
        </div>
      </div>
    );
  }

  renderDefaultHistoryTab() {
    if (this.state.tab.brands === 'new') { return ; }
    return (
      <Nav bsStyle="pills"
        activeKey={this.state.tab.terms}
        onSelect={this.handleTabChange.bind(this, 'terms')}
        style={{ marginBottom: '10px' }}>
        <NavItem eventKey="default">Default</NavItem>
        <NavItem eventKey="history">History</NavItem>
      </Nav>);
  }

  renderBrandsNav() {
    return (
     <div className="col-md-6" style={{ marginBottom: '10px' }}>
      <Nav bsStyle="tabs"
           onSelect={this.handleTabChange.bind(this, 'brands')}
           activeKey={this.state.tab.brands}
        >
        <NavItem key="default" eventKey="default">All Brands</NavItem>
        {this.renderBrandList()}
        <NavItem key="new" eventKey="new"><i className="glyphicon glyphicon-plus"></i>&nbsp;</NavItem>
      </Nav>
     </div>
    );
  }

  renderBrandList() {
    if (!this.props.supplier || !(this.props.supplier.termsByVendor)) { return ; }
    return this.props.supplier.termsByVendor.map(this.renderBrand);
  }

  renderBrand(termsByVendor) {
    let vendorId = termsByVendor['default']['vendorId'];
    if (!vendorId) {
      return ;
    }
    let vendorName = termsByVendor['default']['vendor']['name'];
    return (<NavItem key={vendorId} eventKey={vendorId}>{vendorName}</NavItem>);
  }

  renderSupplierTab() {
    switch (this.state.tab.supplier) {
    case 'details':
      return this.renderSupplier();
    case 'contacts':
      return (
        <SupplierContactsTable supplier={this.props.supplier}
                               onContactAdd={this.handleContactSave.bind(this)}
                               onContactEdit={this.handleContactSave.bind(this)} />
      );
    case 'buyers':
      return (
        <SupplierBuyersTable supplier={this.props.supplier}
                             onBuyerAdd={this.handleBuyerSave.bind(this)}
                             onBuyerEdit={this.handleBuyerSave.bind(this)} />
      );
    }
  }

  renderTermsTab() {
    let tabTerms = this.state.tab.terms;
    if (this.state.tab.brands === 'new') {
      tabTerms = 'default';
    }
    switch (tabTerms) {
    case 'default':
      return (
        <SupplierTermsDefault supplier={this.props.supplier}
                              seasons={this.props.seasons}
                              onTermsSave={this.handleTermsSave.bind(this)}
                              brand={this.state.tab.brands}
                              brands={this.props.brands} />
      );
    case 'history':
      return (
        <SuppliersTermsTable terms={this.getTermHistoryByBrand()}
                             termsSelected={[]}
                             brand={this.state.tab.brands} />
      );
    }
  }

  getTermHistoryByBrand() {
    let brand = this.state.tab.brands;
    if (brand === 'default') {
      brand = null;
    }
    if (!(this.props.supplier.termsByVendor)) {
      return this.props.supplier.terms;
    }
    let history = [];
    this.props.supplier.termsByVendor.forEach( (term) => {
      if (term['default']['vendorId'] === brand) {
        history = term['history'];
      }
    });
    return history;
  }

  renderSupplier() {
    if (this.state.editingSupplier) {
      return (
        <SuppliersForm title="Edit Supplier"
                       submitText="Save"
                       supplier={this.props.supplier}
                       onSubmitSupplier={this.handleSupplierEdit.bind(this)} />
      );
    } else {
      return (
        <div>
          <table className="table">
            <tbody>
              <tr>
                <th style={{ border: '0' }}>Returns Address</th>
                <td style={{ border: '0' }}>{this.renderReturnsAddress()}</td>
              </tr>

              <tr>
                <th>Returns Process</th>
                <td>{this.props.supplier.returnsProcess}</td>
              </tr>

              <tr>
                <th>Invoicer name</th>
                <td>{this.props.supplier.invoicerName}</td>
              </tr>

              <tr>
                <th>Account Number</th>
                <td>{this.props.supplier.accountNumber}</td>
              </tr>

              <tr>
                <th>Country of Origin</th>
                <td>{this.props.supplier.countryOfOrigin}</td>
              </tr>

              <tr>
                <th>Needed for Intrastat?</th>
                <td>{this.props.supplier.neededForIntrastat ? '✔' : '✘'}</td>
              </tr>

              <tr>
                <th>Discontinued?</th>
                <td>{this.props.supplier.discontinued ? '✔' : '✘'}</td>
              </tr>
            </tbody>
          </table>

          <button className="btn btn-success"
                  onClick={() => this.setState({ editingSupplier: true })}>
            Edit supplier
          </button>
        </div>
      );
    }
  }

  renderReturnsAddress() {
    const addressParts = compact(at(this.props.supplier, ['returnsAddressName',
                                                          'returnsAddressNumber',
                                                          'returnsAddress1',
                                                          'returnsAddress2',
                                                          'returnsAddress3',
                                                          'returnsPostalCode']));

    return flatten(map(addressParts, (part, i) => {
      return [(<span key={i}>{part}</span>), (<br key={`br-${i}`} />)];
    }));
  }

  handleTabChange(tabGroup, nextTab) {
    const tab = assign({}, this.state.tab, { [tabGroup]: nextTab });
    this.setState({ tab });
  }

  handleSupplierEdit(supplier) {
    this.setState({ editingSupplier: false });
    this.props.dispatch(editSupplier(supplier));
  }

  handleContactSave(contact) {
    this.props.dispatch(saveSupplierContact(this.props.supplier.id, contact));
  }

  handleTermsSave(terms) {
    if (this.state.tab.brands === 'new') {
      this.setState({switchBrandsTab: parseInt(terms.vendorId, 10)});
    }
    this.props.dispatch(saveSupplierTerms(this.props.supplier.id, terms));
  }

  handleBuyerSave(buyer) {
    this.props.dispatch(saveSupplierBuyer(this.props.supplier.id, buyer));
  }
}

function applyState({ filters, suppliers }) {
  return assign({}, filters, suppliers);
}

export default connect(applyState)(SuppliersEdit);
