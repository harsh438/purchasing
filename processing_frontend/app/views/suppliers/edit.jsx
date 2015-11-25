import React from 'react';
import { connect } from 'react-redux';
import { map, assign } from 'lodash';
import SuppliersForm from './_form';
import { loadSupplier, editSupplier } from '../../actions/suppliers';
import { SupplierContacts } from './contacts';

class SuppliersEdit extends React.Component {
  componentWillMount () {
    this.props.dispatch(loadSupplier(this.props.params.id));
  }

  render() {
    return (
      <div className="suppliers_edit" style={{ marginTop: '70px' }}>
        <div className="col-xs-3 pull-left">
          <SuppliersForm submitText="Edit"
                         supplier={this.props.supplier}
                         onSubmitSupplier={this.handleOnEditSupplier.bind(this)} />
        </div>
        <div className="col-xs-9">
          <SupplierContacts supplier={this.props.supplier} />
        </div>
      </div>
    );
  }

  handleClickEditSupplier(id) {
    this.props.history.pushState(null, `/suppliers/${id}/edit`);
  }

  handleOnEditSupplier(supplier) {
    this.props.dispatch(editSupplier(supplier));
  }
}

function applyState({ supplier }) {
  return supplier;
}

export default connect(applyState)(SuppliersEdit);
