import React from 'react';
import { assign, isPlainObject, map } from 'lodash';

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
                <select className="form-control"
                        id="buyerDepartment"
                        name="department"
                        value={this.state.buyer.department}>
                  <option value=""> -- select department -- </option>
                  {this.renderSelectOptions(this.departments())}
                </select>
              </td>

              <th>
                <label htmlFor="buyerBusinessUnit">Business Unit</label>
              </th>
              <td>
                <select className="form-control"
                        id="buyerBusinessUnit"
                        name="businessUnit"
                        value={this.state.buyer.businessUnit}>
                  <option value=""> -- select business unit -- </option>
                  {this.renderSelectOptions(this.businessUnits())}
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
    );
  }

  renderSelectOptions(options) {
    return map(options, function (option) {
      let id, name;
      
      if (isPlainObject(option)) {
        id = option.id;
        name = option.name;
      } else {
        id = option;
        name = option;
      }

      return (
        <option key={id} value={id}>{name}</option>
      );
    });
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

  departments() {
    return ['Mens',
            'Womens',
            'Footwear',
            'Accessories',
            'Swim',
            'Outdoor',
            'Fitness',
            'Kids',
            'Hardware',
            'Own brand'];
  }

  businessUnits() {
    return ['Apparel', 'Hardware'];
  }
}
