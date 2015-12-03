import React from 'react';
import { map } from 'lodash';

export default class VendorsAssociateSupplierForm extends React.Component {
  componentWillMount() {
    this.state = { submitting: false };
  }

  componentWillReceiveProps(nextProps) {
    this.setState({ submitting: false });
  }

  render() {
    return (
      <div className="panel panel-default">
        <div className="panel-heading">
          <h3 className="panel-title">Add Supplier to Brand</h3>
        </div>

        <div className="panel-body">
          <form className="form"
                onChange={this.handleFormChange.bind(this)}
                onSubmit={this.handleFormSubmit.bind(this)}>
            <table className="table">
              <tbody>
                <tr>
                  <td>
                    <label htmlFor="supplierId">Supplier</label>
                  </td>
                  <td>
                    <select className="form-control"
                            id="supplierId"
                            name="supplierId"
                            value={this.state.supplierId}>
                      <option value=""> -- select supplier -- </option>
                      {this.renderSelectOptions(this.props.suppliers)}
                    </select>
                  </td>
                </tr>
              </tbody>
            </table>

            <button className="btn btn-success"
                    disabled={this.state.submitting}>
              {this.submitText()}
            </button>
          </form>
        </div>
      </div>
    );
  }

  renderSelectOptions(options) {
    return map(options, function ({ id, name }) {
      return (
        <option key={id} value={id}>{name}</option>
      );
    });
  }

  submitText() {
    if (this.state.submitting) {
      return 'Adding supplier...';
    } else {
      return 'Add supplier';
    }
  }

  handleFormChange({ target }) {
    this.setState({ [target.name]: target.value });
  }

  handleFormSubmit(e) {
    e.preventDefault();
    this.setState({ submitting: true });
    this.props.onAssociateSupplier(this.state.supplierId);
  }
}
