import React from 'react';
import SupplierTerms from './_terms';
import SupplierTermsForm from './_form';
import { Link } from 'react-router';

export default class SupplierTermsDefault extends React.Component {
  componentWillMount() {
    this.state = { editingTerms: false };
  }

  render() {
    if (this.state.editingTerms) {
      return this.renderTermsForm();
    } else if (this.props.supplier.defaultTerms) {
      return this.renderTermsView();
    } else {
      return this.renderEmptyTerms();
    }
  }

  renderTermsForm() {
    return (
      <SupplierTermsForm terms={this.props.supplier.defaultTerms}
                         seasons={this.props.seasons}
                         onFormSubmit={this.handleTermsSave.bind(this)} />
    );
  }

  renderTermsView() {
    return (
      <div>
        <SupplierTerms terms={this.props.supplier.defaultTerms} />

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
