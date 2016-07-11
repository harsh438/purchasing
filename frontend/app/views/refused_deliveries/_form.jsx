import React from 'react';
import { assign, omit, get, map } from 'lodash';
import { camelizeKeys } from '../../utilities/inspection';
import Select from 'react-select';
import moment from 'moment';
import { renderSelectOptions,
         renderMultiSelectOptions } from '../../utilities/dom';

export default class RefusedDeliveriesForm extends React.Component {
  componentWillMount() {
    const deliveryDate = moment().format('YYYY-MM-DD');
    this.state = assign({ deliveryDate, submitting: false }, this.props.refusedDelivery);
  }

  componentWillReceiveProps(nextProps) {
    this.setState({ submitting: false });

    if (nextProps.refusedDelivery) {
      this.setState(nextProps.refusedDelivery);
    }
  }

  render() {
    return (
      <form className="form"
            onChange={this.handleFormChange.bind(this)}
            onSubmit={this.handleFormSubmit.bind(this)}>
        <table className="table">
          <tbody>
            <tr>
              <td><label htmlFor="delivery_date">Delivery Date</label></td>
              <td><input className="form-control"
                                name="deliveryDate"
                                id="deliveryDate"
                                type="date"
                                required
                                value={this.state.deliveryDate} /></td>
            </tr>
            <tr>
                <td><label htmlFor="courier">Courier</label></td>
                <td><input className="form-control"
                           id="courier"
                           name="courier"
                           placeholder="courier"
                           required
                           value={this.state.courier} /></td>
            </tr>
            <tr>
                <td><label htmlFor="brandId">Brand</label></td>
                <td><select className="form-control"
                            id="brandId"
                            name="brandId"
                            required
                            value={this.state.brandId}>
                    <option value=""> -- select brand -- </option>
                    {this.selectOptions(this.props.brands)}
                  </select></td>
            </tr>
            <tr>
                <td><label htmlFor="pallets">Pallets</label></td>
                <td><input type="number"
                           className="form-control"
                           id="pallets"
                           name="pallets"
                           placeholder="0"
                           step="0.0001"
                           required
                           value={this.state.pallets} /></td>
            </tr>
            <tr>
                <td><label htmlFor="boxes">Boxes</label></td>
                <td><input type="number"
                           className="form-control"
                           id="boxes"
                           name="boxes"
                           placeholder="0"
                           required
                           value={this.state.boxes} /></td>
            </tr>
            <tr>
                <td><label htmlFor="info">Po Numbers and any other info</label></td>
                <td><textarea className="form-control"
                              id="info"
                              name="info"
                              placeholder="info"
                              required
                              value={this.state.info} /></td>
            </tr>
            <tr>
                <td><label htmlFor="refusalReason">Reason for refusal</label></td>
                <td><input className="form-control"
                           id="refusalReason"
                           name="refusalReason"
                           placeholder="refusal reason"
                           required
                           value={this.state.refusalReason} /></td>
            </tr>
          </tbody>
        </table>

        <button className="btn btn-success"
                disabled={this.state.submitting}>
          {this.props.submitText}
        </button>
      </form>
    );
  }

  selectOptions(options) {
    return map(options, function ({ id, name }) {
      return (
        <option key={id} value={id}>{name}</option>
      );
    });
  }

  getFilter(field) {
    return get(this.state.filters, field, '');
  }

  handleFormChange({ target }) {
    this.setState({ [target.name]: target.value });
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
    this.props.onSubmitRefusedDelivery(this.state);
  }
}
