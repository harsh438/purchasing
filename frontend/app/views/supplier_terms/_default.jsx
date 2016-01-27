import React from 'react';
import SupplierTerms from './_terms';
import SupplierTermsForm from './_form';
import { Link } from 'react-router';
import { filter } from 'lodash';

export default class SupplierTermsDefault extends React.Component {
  componentWillMount() {
    this.state = { editingTerms: false };
  }

  componentWillReceiveProps(nextProps) {
    this.setState({ editingTerms: false });
  }

  render() {
    let term = this.getTermByBrand();
    if (this.state.editingTerms || this.props.brand === 'new') {
      return this.renderTermsForm(term || {});
    } else if (term) {
      return this.renderTermsView(term);
    } else {
      return this.renderEmptyTerms();
    }
  }

  renderTermsForm(term) {
    return (
      <SupplierTermsForm terms={term}
                         seasons={this.props.seasons}
                         onFormSubmit={this.handleTermsSave.bind(this)}
                         brand={this.props.brand}
                         brands={this.props.supplier.vendors} />
    );
  }

  getTermByBrand() {
    let brand = this.props.brand;
    if (brand === 'default') {
      brand = null;
    }
    if (!(this.props.supplier.termsByVendor)) {
      return this.props.supplier.defaultTerms;
    }
    const vendorTerms = filter(this.props.supplier.termsByVendor, terms => terms.default.vendorId === brand);
    return (vendorTerms[0] || {}).default;
  }

  renderTermsView(term) {
    return (
      <div>
        <SupplierTerms terms={term} />

        <p>
          <button className="btn btn-success"
                   onClick={() => this.setState({ editingTerms: true })}>
            Edit terms
          </button>
        </p>
      </div>
    );
  }

  renderEmptyTerms() {
    return (
      <div>
        <p>
          <em>This supplier does not have any terms</em>
        </p>

        <p>
          <button className="btn btn-success"
                  onClick={() => this.setState({ editingTerms: true })}>
            Add terms
          </button>
        </p>
      </div>
    );
  }

  handleTermsSave(terms) {
    this.setState({ editingTerms: false });
    this.props.onTermsSave(terms);
  }
}
