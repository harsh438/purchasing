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
    	<div className="panel panel-default">
    			<div className="panel-heading">
    				<h3 className="panel-title">Suppliers</h3>
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
			        <div className="panel panel-default">
    						<div className="panel-heading">
    							<h3 className="panel-title">Returns Address</h3>
    						</div>
			        	<div className="panel-body">
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
						          <label forHtml="return_address_name">Line 1</label>
						          <input className="form-control"
						                 id="returns_address_1"
						                 name="returns_address_1"
						                 placeholder="Line 1"
						                 value={this.state.returnsAddress1} />

									</div>
						      <div className="form-group">
						          <label forHtml="return_address_name">Line 2</label>
						          <input className="form-control"
						                 id="returns_address_2"
						                 name="returns_address_2"
						                 placeholder="Line 2"
						                 value={this.state.returnsAddress2} />

									</div>
						      <div className="form-group">
						          <label forHtml="return_address_name">Line 3</label>
						          <input className="form-control"
						                 id="returns_address_3"
						                 name="returns_address_3"
						                 placeholder="Line 3"
						                 value={this.state.returnsAddress3} />

									</div>																																			
								</div>
							</div>
			        <div className="form-group">
			            <button className="btn btn-success"
			                    disabled={this.state.submitting}>
			              {this.props.submitText}
			            </button>
			        </div>
			      </form>
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
