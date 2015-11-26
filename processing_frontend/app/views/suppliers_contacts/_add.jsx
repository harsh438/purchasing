import React from 'react';
import { assign } from 'lodash';
import SupplierContact from './_form';

export default class SupplierAddContact extends React.Component {
  componentWillMount() {
    this.state = assign({contact: {}}, this.props.supplier);
  }

  render() {
    return (<div className="panel panel-default">
              <div className="panel-heading">
                <h3 className="panel-title">Add Contact</h3>
              </div>
              <div className="panel-body">
                <SupplierContact submitText="Add Contact"
                                 contact={this.state.contact}
                                 onSubmitContact={this.props.onAddContact} />
              </div>
            </div>
    );
  }
}
