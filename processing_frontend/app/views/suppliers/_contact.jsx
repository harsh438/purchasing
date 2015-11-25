import React from 'react';
import { assign } from 'lodash';

export class SupplierAddContact extends React.Component {
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

export class SupplierContact extends React.Component {
  componentWillMount() {
    this.state = this.props.contact || {};
  }

  render () {
    return (<div className="panel panel-default">
      <div className="panel-body">
      <form onChange={this.handleFormChange.bind(this)}>
        <table className="table">
          <tbody>
            <tr>
              <th>Name</th>
              <td><input name="name" className="form-control" value={ this.state.name } /></td>
            </tr>
            <tr>
              <th>Title</th>
              <td><input name="title" className="form-control" value={ this.state.title } /></td>
            </tr>
            <tr>
              <th>Mobile</th>
              <td><input name="mobile" className="form-control" value={ this.state.mobile } /></td>
            </tr>
            <tr>
              <th>Landline</th>
              <td><input name="landline" className="form-control" value={ this.state.landline } /></td>
            </tr>
            <tr>
              <th>Email</th>
              <td><input name="email" className="form-control" value={ this.state.email } /></td>
            </tr>
            <tr>
              <td></td>
              <td><input type="button" className="btn btn-success" value={ this.props.submitText }
                         onClick={ () => this.props.onSubmitContact(this.state) }/></td>
            </tr>
          </tbody>
        </table>
      </form>
    </div>
    </div>);
  }

  handleFormChange ({ target }) {
    this.setState({ [target.name]: target.value });
  }
}
