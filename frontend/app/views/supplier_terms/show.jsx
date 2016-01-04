import React from 'react';
import { loadSingleSupplierTerms } from '../../actions/supplier_terms';
import { connect } from 'react-redux';
import { assign } from 'lodash';
import SupplierTerms from './_terms';
import { Link } from 'react-router';

class SupplierTermsShow extends React.Component {
  componentWillMount () {
    this.state = { id: this.props.params.id };
    this.props.dispatch(loadSingleSupplierTerms(this.props.params.id));
  }

  componentWillReceiveProps(nextProps) {
    if (this.state.id !== nextProps.params.id) {
      this.setState({ id: nextProps.params.id });
      this.props.dispatch(loadSingleSupplierTerms(nextProps.params.id));
    }
  }

  render() {
    return (
      <div className="suppliers_terms_show container-fluid" style={{ marginTop: '70px' }}>
        <div className="row" style={{ marginBottom: '20px' }}>
          <div className="col-md-12">
            <h1>
              <Link to="/suppliers">Suppliers</Link>
              &nbsp;/&nbsp;
              <Link to={`/suppliers/${this.props.singleSupplierTerms.supplierId}/edit`}>
                {this.props.singleSupplierTerms.supplierName}
              </Link>
              &nbsp;/&nbsp;
              {this.props.singleSupplierTerms.createdAt}
            </h1>
          </div>
        </div>

        <div className="row">
          <div className="col-md-6">
            <SupplierTerms terms={this.props.singleSupplierTerms} />
          </div>
        </div>
      </div>
    );
  }

  renderBackLink() {
    if (this.props.singleSupplierTerms) {
      return (
        <Link className="pull-right" to={`/suppliers/${this.props.singleSupplierTerms.supplierId}/terms`}>
          <span className="glyphicon glyphicon-arrow-left"></span>&nbsp;Go back to terms history
        </Link>
      );
    }
  }
}


function applyState({ supplierTerms }) {
  return assign({}, supplierTerms);
}

export default connect(applyState)(SupplierTermsShow);
