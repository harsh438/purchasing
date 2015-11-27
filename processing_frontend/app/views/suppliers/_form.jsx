import React from 'react';
import { assign, omit } from 'lodash';
import { camelizeKeys } from '../../utilities/inspection';

export default class SuppliersForm extends React.Component {
  componentWillMount() {
    this.state = assign({ submitting: false }, this.props.supplier);
  }

  componentWillReceiveProps(nextProps) {
    this.setState({ submitting: false });

  	if (nextProps.supplier) {
	  	this.setState(nextProps.supplier);
	  }
	}

  render() {
    return (
        <div className="panel panel-default">
          <div className="panel-heading">
            <h3 className="panel-title">{this.props.title}</h3>
          </div>
          <div className="panel-body">
            <form className="form"
                  onChange={this.handleFormChange.bind(this)}
                  onSubmit={this.handleFormSubmit.bind(this)}>
              <table className="table">
                <tbody>
                  <tr>
                    <td><label forHtml="supplier_name">Name</label></td>
                    <td><input className="form-control"
                           id="supplier_name"
                           name="name"
                           placeholder="Name"
                           required
                           value={this.state.name} /></td>
                  </tr>
                  <tr>
                      <td><label forHtml="return_address_name">Address Name</label></td>
                      <td><input className="form-control"
                             id="returns_address_name"
                             name="returns_address_name"
                             placeholder="Return Address Name"
                             required
                             value={this.state.returnsAddressName} /></td>
                  </tr>
                  <tr>
                      <td><label forHtml="return_address_name">Address Number</label></td>
                      <td><input className="form-control"
                             id="returns_address_number"
                             name="returns_address_number"
                             placeholder="Return Address Number"
                             value={this.state.returnsAddressNumber} /></td>
                  </tr>
                  <tr>
                      <td><label forHtml="return_address_1">Returns Address Line 1</label></td>
                      <td><input className="form-control"
                             id="returns_address_1"
                             name="returns_address_1"
                             placeholder="Line 1"
                             value={this.state.returnsAddress1} /></td>
                  </tr>
                  <tr>
                      <td><label forHtml="returns_address_2">Returns Address Line 2</label></td>
                      <td><input className="form-control"
                             id="returns_address_2"
                             name="returns_address_2"
                             placeholder="Line 2"
                             value={this.state.returnsAddress2} /></td>
                  </tr>
                  <tr>
                      <td><label forHtml="returns_address_3">Returns Address Line 3</label></td>
                      <td><input className="form-control"
                             id="returns_address_3"
                             name="returns_address_3"
                             placeholder="Line 3"
                             value={this.state.returnsAddress3} /></td>
                  </tr>
                  <tr>
                      <td><label forHtml="return_address_name">Returns Postal Code</label></td>
                      <td><input className="form-control"
                             id="returns_postal_code"
                             name="returns_postal_code"
                             placeholder="Postal Code"
                             value={this.state.returnsPostalCode} /></td>
                  </tr>
                  <tr>
                      <td><label forHtml="returns_process">Return Process</label></td>
                      <td><input className="form-control"
                             id="returns_process"
                             name="returns_process"
                             placeholder="Return Process"
                             value={this.state.returnsProcess} /></td>
                  </tr>
                  <tr>
                      <td><label forHtml="invoicer_name">Invoicer Name</label></td>
                      <td><input className="form-control"
                             id="invoicer_name"
                             name="invoicer_name"
                             placeholder="Invoicer Name"
                             value={this.state.invoicerName} /></td>
                  </tr>
                  <tr>
                      <td><label forHtml="account_number">Account Number</label></td>
                      <td><input className="form-control"
                             id="account_number"
                             name="account_number"
                             placeholder="Account Number"
                             value={this.state.accountNumber} /></td>
                  </tr>
                  <tr>
                      <td><label forHtml="country_of_origin">Country Of Origin</label></td>
                      <td><input className="form-control"
                             id="country_of_origin"
                             name="country_of_origin"
                             placeholder="Country Of Origin"
                             value={this.state.countryOfOrigin} /></td>
                  </tr>
                  <tr>
                    <td>
                      <div className="checkbox">
                        <label>
                          <input type="checkbox"
                                 name="discontinued"
                                 value="1"
                                 className="checkbox"
                                 checked={this.state.discontinued}
                                 onChange={this.handleCheckboxChange.bind(this)} />

                          Discontinued
                        </label>
                      </div>
                      </td><td></td>
                  </tr>
                  <tr>
                    <td></td><td><button className="btn btn-success col-xs-6"
                            disabled={this.state.submitting}>
                      {this.props.submitText}
                    </button></td>
                  </tr>
                </tbody>
              </table>
            </form>
          </div>
        </div>
    );
  }

  handleFormChange({ target }) {
    this.setState(camelizeKeys({ [target.name]: target.value }));
  }

  handleCheckboxChange(e) {
    e.stopPropagation();

    if (e.target.checked) {
      this.handleFormChange(e);
    } else {
      this.setState({ [e.target.name]: '0' });
    }
  }

  handleFormSubmit(e) {
    e.preventDefault();
    this.setState({ submitting: true });
    this.props.onSubmitSupplier(this.state);
  }
}
