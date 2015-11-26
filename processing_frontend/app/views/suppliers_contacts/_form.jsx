import React from 'react';

export default class SupplierContact extends React.Component {
  componentWillMount() {
    this.state = this.props.contact || {};
  }

  componentWillReceiveProps(nextProps) {
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
