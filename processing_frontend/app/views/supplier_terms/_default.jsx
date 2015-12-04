import React from 'react';
import SupplierTerms from './_terms';
import SupplierTermsForm from './_form';
import { Link } from 'react-router';

export default class SupplierTermsDefault extends React.Component {
  componentWillMount() {
    this.state = { editingTerms: false };
  }

  render() {
    return (
      <div className="panel panel-default">
        <div className="panel-heading">
          <h3 className="panel-title">Default Terms</h3>
        </div>
        <div className="panel-body">
          {this.renderPanelBody()}
        </div>
      </div>
    );
  }

  renderPanelBody() {
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

          {this.renderPreviousVersionLink()}

          <Link className="btn btn-default pull-right" to={`/suppliers/${this.props.supplier.id}/terms`}>
            View terms history
          </Link>
        </p>
      </div>
    );
  }

  renderPreviousVersionLink() {
    if (this.props.supplier.defaultTerms.parentId) {
      return (
        <Link className="btn btn-default pull-right"
              to={`/suppliers/term/${this.props.supplier.defaultTerms.parentId}`}>
          <span className="glyphicon glyphicon-arrow-left"></span>
          &nbsp;View previous version
        </Link>
      );
    }
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
