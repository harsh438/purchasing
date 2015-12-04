import React from 'react';
import { assign } from 'lodash';

export default class SupplierBuyerForm extends React.Component {
  componentWillMount() {
    console.log(this.props.buyer);
    
    this.state = { buyer: this.props.buyer,
                   submitting: false };
  }

  componentWillReceiveProps(nextProps) {
    this.setState({ submitting: false });
  }

  render () {
    return (
      <form onChange={this.handleFormChange.bind(this)}
            onSubmit={this.handleFormSubmit.bind(this)}>
        <table className="table" style={{ tableLayout: 'fixed' }}>
          <tbody>
            <tr>
              <th>
                <label htmlFor="buyerName">Buyer name</label>
              </th>
              <td>
                <input id="buyerName"
                       name="buyerName"
                       value={this.state.buyer.buyerName}
                       className="form-control" />
              </td>

              <th>
                <label htmlFor="assistantName">Assistant name</label>
              </th>
              <td>
                <input id="assistantName"
                       name="assistantName"
                       value={this.state.buyer.assistantName}
                       className="form-control" />
              </td>
            </tr>

            <tr>
              <th>
                <label htmlFor="buyerDepartment">Department</label>
              </th>
              <td>
                <input id="buyerDepartment"
                       name="department"
                       value={this.state.buyer.department}
                       className="form-control" />
              </td>

              <th>
                <label htmlFor="buyerBusinessUnit">Business Unit</label>
              </th>
              <td>
                <input id="buyerBusinessUnit"
                       name="businessUnit"
                       value={this.state.buyer.businessUnit}
                       className="form-control" />
              </td>
            </tr>
          </tbody>
        </table>

        <button className="btn btn-success"
                disabled={this.state.submitting}>
          {this.submitText()}
        </button>
      </form>
    );
  }

  submitText() {
    if (this.state.submitting) {
      return this.props.submittingText;
    } else {
      return this.props.submitText;
    }
  }

  handleFormChange ({ target }) {
    const buyer = assign({}, this.state.buyer, { [target.name]: target.value });
    this.setState({ buyer });
  }

  handleFormSubmit(e) {
    e.preventDefault();
    this.setState({ submitting: true });
    this.props.onFormSubmit(this.state.buyer);
  }
}
