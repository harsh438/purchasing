import React from 'react';
import { assign, omit } from 'lodash';
import { camelizeKeys } from '../../utilities/inspection';

export default class VendorsForm extends React.Component {
  componentWillMount() {
    this.state = assign({ submitting: false }, this.props.vendor);
  }

  componentWillReceiveProps(nextProps) {
    this.setState({ submitting: false });

    if (nextProps.vendor) {
      this.setState(nextProps.vendor);
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
                  <td><label htmlFor="vendor_name">Name</label></td>
                  <td><input className="form-control"
                             id="vendor_name"
                             name="name"
                             placeholder="Name"
                             required
                             value={this.state.name} /></td>
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
                  </td>
                  <td></td>
                </tr>
              </tbody>
            </table>

            <button className="btn btn-success"
                    disabled={this.state.submitting}>
              {this.props.submitText}
            </button>
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
      this.setState({ [e.target.name]: false });
    }
  }

  handleFormSubmit(e) {
    e.preventDefault();
    this.setState({ submitting: true });
    this.props.onSubmitVendor(this.state);
  }
}
