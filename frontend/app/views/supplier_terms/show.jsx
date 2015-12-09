import React from 'react';
import { loadSupplierTerms } from '../../actions/supplier_terms';
import { connect } from 'react-redux';
import { assign } from 'lodash';
import SupplierTerms from './_terms';
import { Link } from 'react-router';

class SupplierTermsShow extends React.Component {
  componentWillMount () {
    this.state = { id: this.props.params.id };
    this.props.dispatch(loadSupplierTerms(this.props.params.id));
  }

  componentWillReceiveProps(nextProps) {
    if (this.state.id !== nextProps.params.id) {
      this.setState({ id: nextProps.params.id });
      this.props.dispatch(loadSupplierTerms(nextProps.params.id));
    }
  }

  render() {
    return (
      <div className="col-md-6 col-md-offset-3">
        <div className="suppliers_terms_show" style={{ marginTop: '70px' }}>
          <div className="panel panel-default">
              <div className="panel-heading" style={{ overflow: 'hidden' }}>
                <h3 className="panel-title pull-left">Term</h3>
                {this.renderBackLink()}
              </div>
              <div className="panel-body">
                <SupplierTerms terms={this.props.supplierTerms} />
              </div>
          </div>
        </div>
      </div>
    );
  }

  renderBackLink() {
    if (this.props.supplierTerms) {
      return (
        <Link className="pull-right" to={`/suppliers/${this.props.supplierTerms.supplierId}/terms`}>
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
