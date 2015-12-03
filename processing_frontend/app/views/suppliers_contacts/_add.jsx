import React from 'react';
import { assign } from 'lodash';
import SupplierContact from './_form';

export default class SupplierAddContact extends React.Component {
  componentWillMount() {
    this.state = assign({ contact: {} }, this.props.supplier);
  }

  render() {
    return (
      <SupplierContact submitText="Add Contact"
                       contact={this.state.contact}
                       onSubmitContact={this.props.onAddContact}
                       editableByDefault />
    );
  }
}
