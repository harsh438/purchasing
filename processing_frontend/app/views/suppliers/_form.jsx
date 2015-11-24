import React from 'react';
import { assign } from 'lodash';

export default class SuppliersForm extends React.Component {
  componentWillMount() {
  		console.log('??????>>', this.props.supplier);
    this.state = assign({ submitting: false }, this.props.supplier);
  }

  componentWillReceiveProps(nextProps) {
  	if (nextProps.supplier) {
  		console.log('??????>>', nextProps.supplier);
	  	this.setState(nextProps.supplier);
	  }
  }

  render() {
    return (
    	<div className="col-md-4">
	    	<div className="panel panel-default">
    			<div className="panel-heading">
    				<h3 className="panel-title">Suppliers {this.props.submitText}</h3>
    			</div>
    			<div className="panel-body">
			      <form className="form"
			            onChange={this.handleFormChange.bind(this)}
			            onSubmit={this.handleFormSubmit.bind(this)}>
			        <div className="form-group">
			          <label forHtml="supplier_name">Name</label>
			          <input className="form-control"
			                 id="supplier_name"
			                 name="name"
			                 placeholder="Name"
			                 required
			                 value={this.state.name} />
			        </div>
				      <div className="form-group">
			          <label forHtml="return_address_name">Address Name</label>
			          <input className="form-control"
			                 id="returns_address_name"
			                 name="returns_address_name"
			                 placeholder="Return Address Name"
			                 required
			                 value={this.state.returnsAddressName} />
							</div>
				      <div className="form-group">
			          <label forHtml="return_address_name">Address Number</label>
			          <input className="form-control"
			                 id="returns_address_number"
			                 name="returns_address_number"
			                 placeholder="Return Address Number"
			                 value={this.state.returnsAddressNumber} />
							</div>
				      <div className="form-group">
			          <label forHtml="return_address_1">Returns Address Line 1</label>
			          <input className="form-control"
			                 id="returns_address_1"
			                 name="returns_address_1"
			                 placeholder="Line 1"
			                 value={this.state.returnsAddress1} />
							</div>
				      <div className="form-group">
			          <label forHtml="returns_address_2">Returns Address Line 2</label>
			          <input className="form-control"
			                 id="returns_address_2"
			                 name="returns_address_2"
			                 placeholder="Line 2"
			                 value={this.state.returnsAddress2} />
							</div>
				      <div className="form-group">
			          <label forHtml="returns_address_3">Returns Address Line 3</label>
			          <input className="form-control"
			                 id="returns_address_3"
			                 name="returns_address_3"
			                 placeholder="Line 3"
			                 value={this.state.returnsAddress3} />
							</div>
				      <div className="form-group">
			          <label forHtml="return_address_name">Returns Postal Code</label>
			          <input className="form-control"
			                 id="returns_postal_code"
			                 name="returns_postal_code"
			                 placeholder="Postal Code"
			                 value={this.state.returnsPostalCode} />
							</div>
				      <div className="form-group">
			          <label forHtml="returns_process">Return Process</label>
			          <input className="form-control"
			                 id="returns_process"
			                 name="returns_process"
			                 placeholder="Return Process"
			                 value={this.state.returnsProcess} />
							</div>
				      <div className="form-group">
			          <label forHtml="invoicer_name">Invoicer Name</label>
			          <input className="form-control"
			                 id="invoicer_name"
			                 name="invoicer_name"
			                 placeholder="Invoicer Name"
			                 value={this.state.invoicerName} />
							</div>
				      <div className="form-group">
			          <label forHtml="account_number">Account Number</label>
			          <input className="form-control"
			                 id="account_number"
			                 name="account_number"
			                 placeholder="Account Number"
			                 value={this.state.accountNumber} />
							</div>
				      <div className="form-group">
			          <label forHtml="country_of_origin">Country Of Origin</label>
			          <input className="form-control"
			                 id="country_of_origin"
			                 name="country_of_origin"
			                 placeholder="Country Of Origin"
			                 value={this.state.countryOfOrigin} />
							</div>
			        <div className="form-group">
		            <button className="btn btn-success col-xs-offset-3 col-xs-6"
		                    disabled={this.state.submitting}>
		              {this.props.submitText}
		            </button>
			        </div>
			      </form>
			    </div>
			  </div>
			</div>
    );
  }

  handleFormChange({ target }) {
    this.setState({ [target.name]: target.value });
  }

  handleFormSubmit(e) {
    e.preventDefault();
    this.setState({ submitting: true });
    this.props.onSubmitSupplier(this.state);
  }
}
