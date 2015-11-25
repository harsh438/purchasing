import React from 'react';
import { assign } from 'lodash';
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
      <form className="form clearfix"
            onChange={this.handleFormChange.bind(this)}
            onSubmit={this.handleFormSubmit.bind(this)}>
        <div className="row no_gutter">
          <div className="form-group col-md-2">
            <label forHtml="supplier_name">Supplier Name</label>
            <input className="form-control"
                   id="supplier_name"
                   name="name"
                   placeholder="Name"
                   required
                   value={this.state.name} />
          </div>

          <div className="form-group col-md-2"
               style={{ paddingTop: '1.6em' }}>
            <div className="checkbox">
              <label>
                <input type="checkbox"
                       name="discontinued"
                       className="checkbox"
                       checked={this.state.discontinued}
                       onChange={this.handleCheckboxChange.bind(this)} />

                Discontinued
              </label>
            </div>
          </div>

          <div className="form-group col-md-2"
               style={{ marginTop: '1.74em' }}>
            <button className="btn btn-success col-xs-offset-3 col-xs-6"
                    disabled={this.state.submitting}>
              Search
            </button>
          </div>
        </div>
      </form>
    );
  }

  handleFormChange({ target }) {
    this.setState(camelizeKeys({ [target.name]: target.value }));
  }

  handleCheckboxChange(e) {
    e.stopPropagation();
    this.setState(camelizeKeys({ [e.target.name]: e.target.checked }));
  }

  handleFormSubmit(e) {
    e.preventDefault();
    this.setState({ submitting: true });
    this.props.onFilterSuppliers(this.state);
  }
}
