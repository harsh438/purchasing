import React from 'react';
import { loadTerms } from '../../actions/supplier_terms';
import { connect } from 'react-redux';
import { assign } from 'lodash';
import SupplierTerms from './_terms';

class SupplierTermsShow extends React.Component {
  componentWillMount () {
    this.state = {id: this.props.params.id};
    this.props.dispatch(loadTerms(this.props.params.id));
  }

  render() {
    console.log('render', this);
    return (
      <div className="suppliers_terms_show" style={{ marginTop: '70px' }}>
        <div className="panel panel-default">
            <div className="panel-heading">
              <h3 className="panel-title">Term</h3>
            </div>
        </div>
        <div className="panel-body">
          <SupplierTerms terms={this.props.terms} />
        </div>
      </div>
      )
  }

}


function applyState({ terms }) {
  return assign({}, terms);
}

export default connect(applyState)(SupplierTermsShow);
