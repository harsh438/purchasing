import React from 'react';
import { assign, get, map, omit, startCase } from 'lodash';

export default class SuppliersForm extends React.Component {
  componentWillMount() {
    this.state = { submitting: false, terms: (this.props.terms || {}) };
  }

  componentWillReceiveProps(nextProps) {
    this.setState({ submitting: false });

    if (nextProps.terms) {
      this.setState({ terms: nextProps.terms });
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
              <td>
                <label htmlFor="season">Season</label>
              </td>
              <td>
                <select className="form-control"
                        id="season"
                        name="season"
                        required
                        value={this.getField('season')}>
                  <option value=""> -- select season -- </option>
                  {this.selectOptions(this.props.seasons)}
                </select>
              </td>
            </tr>

            {this.renderTextFields()}

            <tr>
              <td>
                <label htmlFor="comments">Comments</label>
              </td>
              <td>
                <textarea className="form-control"
                          id="comments"
                          name="comments"
                          value={this.getField('comments')} />
              </td>
            </tr>

            {this.renderCheckboxField('samples')}
            {this.renderCheckboxField('productImagery')}

            <tr>
              <td></td>
              <td>
                <button className="btn btn-success col-xs-offset-3 col-xs-6"
                        disabled={this.state.submitting}>
                  {this.submitText()}
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </form>
    );
  }

  renderTextFields() {
    return map([['creditLimit', ''],
                ['preOrderDiscount', ''],
                ['creditTermsPreOrder', ''],
                ['reOrderDiscount', ''],
                ['creditTermsReOrder', ''],
                ['faultyReturnsDiscount', ''],
                ['settlementDiscount', ''],
                ['marketingContribution', ''],
                ['rebateStructure', ''],
                ['riskOrderDetails', ''],
                ['markDownContributionDetails', ''],
                ['cancellationAllowance', ''],
                ['stockSwapAllowance', ''],
                ['bulkOrderDetails', ''],
                ['agreedWith', 'Supplier staff name'],
                ['by', 'Buyers name']],
               this.renderTextField,
               this);
  }

  renderTextField([field, hint], i) {
    return (
      <tr key={i}>
        <td>
          <label htmlFor={field}>{startCase(field)}</label>
        </td>
        <td>
          <input className="form-control"
                 id={field}
                 name={field}
                 placeholder={hint}
                 value={this.getField(field)} />
        </td>
      </tr>
    );
  }

  renderCheckboxField(field) {
    return (
      <tr>
        <td colSpan="2">
          <div className="checkbox">
            <label>
              <input type="checkbox"
                     name={field}
                     value="1"
                     className="checkbox"
                     checked={this.getField(field)}
                     onChange={this.handleCheckboxChange.bind(this)} />

              {startCase(field)}
            </label>
          </div>
        </td>
      </tr>
    );
  }

  submitText() {
    if (this.state.submitting) {
      return 'Saving...';
    } else {
      return 'Save';
    }
  }

  getField(field) {
    switch (field) {
      case 'samples':
      case 'productImagery':
        return this.state.terms[field] === '1';
      default:
        return get(this.state.terms, field, '');
    }
  }

  selectOptions(options) {
    return map(options, function ({ id, name }) {
      return (
        <option key={id} value={id}>{name}</option>
      );
    });
  }

  handleFormChange({ target }) {
    const terms = assign({}, this.state.terms, { [target.name]: target.value });
    this.setState({ terms });
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
    this.props.onFormSubmit(this.state.terms);
  }
}
