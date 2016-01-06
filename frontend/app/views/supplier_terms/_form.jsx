import React from 'react';
import DropZone from 'react-dropzone';
import { assign, get, map, omit, startCase, pick } from 'lodash';

export default class SupplierTermsForm extends React.Component {
  componentWillMount() {
    this.state = { submitting: false, terms: this.props.terms };
  }

  componentWillReceiveProps(nextProps) {
    this.setState({ submitting: false });
    // the file has to be re-uploaded every time anyway
    this.setTerms({ terms: nextProps.terms });
  }

  render() {
    return (
      <form className="form"
            onChange={this.handleFormChange.bind(this)}
            onSubmit={this.handleFormSubmit.bind(this)}>
        <table className="table">
          <colgroup>
            <col style={{ width: '45%' }} />
          </colgroup>

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

            {this.renderMoneyField('creditLimit')}
            {this.renderPercentageField('preOrderDiscount')}
            {this.renderNumOfDaysField('creditTermsPreOrder')}
            {this.renderPercentageField('reOrderDiscount')}
            {this.renderNumOfDaysField('creditTermsReOrder')}
            {this.renderPercentageField('faultyReturnsDiscount')}
            {this.renderSettlementDiscountField()}
            {this.renderMarketingContributionField()}
            {this.renderTextField(['rebateStructure', ''], 'rebateStructure')}
            {this.renderRiskOrderAgreement()}
            {this.renderMarkdownContributionDetails()}
            {this.renderPercentageField('preOrderCancellationAllowance')}
            {this.renderPercentageField('preOrderStockSwapAllowance')}
            {this.renderCheckboxDate('bulkOrderAgreement')}
            {this.renderCheckboxDate('saleOrReturnAgreement')}
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
              <td colSpan="2">
                <div>
                  <DropZone multiple={false}
                            onDrop={this.handleFile.bind(this)}
                            style={{ color: '#999', padding: '30px', border: '2px dashed #999' }}
                            accept=".jpg,.jpeg,.png,.pdf,.eml">
                    <div>Confirmation file for the terms. Try dropping some files here, or click to select files to upload.</div>
                    {this.renderFileUploadText()}
                  </DropZone>
                </div>
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

  renderFileUploadText() {
    if (this.state.terms.confirmationFileName) {
      return (
        <div style={{ margin: '5px 10px 0 10px' }}>
          <span className="glyphicon glyphicon-open-file"></span>
          <span style={{ color: 'grey' }}>File to upload: {this.state.terms.confirmationFileName}</span>
        </div>
      );
    }
  }

  renderTextFields() {
    return map(this.getTextFieldList(), this.renderTextField, this);
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

  renderMoneyField(field) {
    return (
      <tr>
        <td>
          <label htmlFor={field}>{startCase(field)}</label>
        </td>
        <td>
          <div className="input-group"
               style={{ width: '100%' }}>
            <span className="input-group-addon">£</span>
            <input className="form-control"
                   type="number"
                   step="1"
                   id={field}
                   name={field}
                   value={this.getField(field)} />
            <span className="input-group-addon"
                  style={{ width: '45px' }}>.00</span>
          </div>
        </td>
      </tr>
    );
  }

  renderPercentageField(field) {
    return (
      <tr>
        <td>
          <label htmlFor={field}>{startCase(field)}</label>
        </td>
        <td>
          <div className="input-group"
               style={{ width: '100%' }}>
            <input className="form-control"
                   type="number"
                   step="any"
                   min="0"
                   max="100"
                   id={field}
                   name={field}
                   value={this.getField(field)} />
            <span className="input-group-addon"
                  style={{ width: '45px' }}>%</span>
          </div>
        </td>
      </tr>
    );
  }

  renderNumOfDaysField(field) {
    return (
      <tr>
        <td>
          <label htmlFor={field}>{startCase(field)}</label>
        </td>
        <td>
          <div className="input-group"
               style={{ width: '100%' }}>
            <input className="form-control"
                   type="number"
                   step="1"
                   id={field}
                   name={field}
                   value={this.getField(field)} />
            <span className="input-group-addon"
                  style={{ width: '45px' }}>days</span>
          </div>
        </td>
      </tr>
    );
  }

  renderMarketingContributionField() {
    return (
      <tr onChange={this.handleNestedFormChange.bind(this, 'marketingContribution')}>
        <td>
          <label htmlFor="marketingContribution">{startCase('marketingContribution')}</label>
        </td>
        <td>
          <div className="input-group pull-left"
               style={{ width: '55%' }}>
            <input className="form-control"
                   type="number"
                   id="marketingContribution"
                   name="marketingContributionPercentage"
                   value={this.getNestedField('marketingContribution', 'percentage')} />
            <span className="input-group-addon">%</span>
          </div>

          <select className="form-control pull-right"
                  name="marketingContributionOf"
                  value={this.getNestedField('marketingContribution', 'of')}
                  style={{ width: '44%' }}>
            <option> -- select -- </option>
            <option value="pre_order_total">Pre Order Total</option>
            <option value="season_total">Season Total</option>
            <option value="year_total">Year Total</option>
          </select>
        </td>
      </tr>
    );
  }

  renderRiskOrderAgreement() {
    return (
      <tr onChange={this.handleNestedFormChange.bind(this, 'riskOrderAgreement')}>
        <td>
          <label htmlFor="riskOrderAgreement">{startCase('riskOrderAgreement')}</label>

          <span className="toggle-field pull-right">
            <input type="checkbox"
                   name="riskOrderAgreementEnabled"
                   checked={this.getNestedField('riskOrderAgreement', 'enabled')} />
          </span>
        </td>
        <td>
          <div className="input-group pull-left"
               style={{ width: '55%' }}>
            <input className="form-control"
                   type="number"
                   id="riskOrderAgreement"
                   name="riskOrderAgreementPercentage"
                   value={this.getNestedField('riskOrderAgreement', 'percentage')}
                   disabled={this.getNestedField('riskOrderAgreement', 'enabled') !== true}
                   required />

            <span className="input-group-addon">%</span>
          </div>

          <input type="date"
                 className="form-control pull-right"
                 name="riskOrderAgreementDate"
                 value={this.getNestedField('riskOrderAgreement', 'date')}
                 style={{ width: '44%' }}
                 disabled={this.getNestedField('riskOrderAgreement', 'enabled') !== true}
                 required />
        </td>
      </tr>
    );
  }

  renderSettlementDiscountField() {
    return (
      <tr onChange={this.handleNestedFormChange.bind(this, 'settlementDiscount')}>
        <td>
          <label htmlFor="settlementDiscount">Settlement Discount</label>
        </td>
        <td>
          <div className="input-group pull-left"
               style={{ width: '55%' }}>
            <input className="form-control"
                   type="number"
                   id="settlementDiscount"
                   name="settlementDiscountPercentage"
                   value={this.getNestedField('settlementDiscount', 'percentage')} />

            <span className="input-group-addon">%</span>
          </div>

          <div className="input-group pull-right"
               style={{ width: '44%' }}>
            <input className="form-control"
                   name="settlementDiscountDays"
                   type="number"
                   step="1"
                   value={this.getNestedField('settlementDiscount', 'days')} />

            <span className="input-group-addon">days</span>
          </div>
        </td>
      </tr>
    );
  }

  renderMarkdownContributionDetails() {
    return (
      <tr onChange={this.handleNestedFormChange.bind(this, 'markdownContributionDetails')}>
        <td>
          <label htmlFor="markdownContributionDetails">Markdown Contribution Details</label>

          <span className="toggle-field pull-right">
            <input type="checkbox"
                   name="markdownContributionDetailsEnabled"
                   checked={this.getNestedField('markdownContributionDetails', 'enabled')} />
          </span>
        </td>

        <td>
          <div className="input-group pull-left"
               style={{ width: '55%' }}>
            <input className="form-control"
                   type="number"
                   id="markdownContributionDetails"
                   name="markdownContributionDetailsPercentage"
                   value={this.getNestedField('markdownContributionDetails', 'percentage')}
                   disabled={this.getNestedField('markdownContributionDetails', 'enabled') !== true}
                   required />

            <span className="input-group-addon">%</span>
          </div>

          <select className="form-control pull-right"
                  name="markdownContributionDetailsOf"
                  value={this.getNestedField('markdownContributionDetails', 'of')}
                  style={{ width: '44%' }}
                  disabled={this.getNestedField('markdownContributionDetails', 'enabled') !== true}
                  required>
            <option> -- select -- </option>
            <option value="pre_orders">Pre orders</option>
            <option value="all_orders">All orders</option>
          </select>
        </td>
      </tr>
    );
  }

  renderCheckboxDate(fieldNs) {
    const field = nestedKey => `${fieldNs}${nestedKey}`;

    return (
      <tr onChange={this.handleNestedFormChange.bind(this, fieldNs)}>
        <td>
          <label htmlFor={field('Enabled')}>{startCase(fieldNs)}</label>

          <span className="toggle-field pull-right">
            <input type="checkbox"
                   name={field('Enabled')}
                   id={field('Enabled')}
                   checked={this.getNestedField(fieldNs, 'enabled')} />
          </span>
        </td>

        <td>
          <input className="form-control"
                 type="date"
                 id={fieldNs}
                 name={field('Date')}
                 value={this.getNestedField(fieldNs, 'date')}
                 disabled={this.getNestedField(fieldNs, 'enabled') !== true}
                 required />
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
                     className="checkbox"
                     value="1"
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
      return this.state.terms[field];
    default:
      return get(this.state.terms, field, '');
    }
  }

  getNestedField(fieldNs, nestedKey) {
    if (this.state.terms[fieldNs]) {
      switch (nestedKey) {
      case 'date':
        if (this.state.terms[fieldNs][nestedKey]) {
          return this.state.terms[fieldNs][nestedKey].split('/').reverse().join('-');
        }
      default:
        return this.state.terms[fieldNs][nestedKey];
      }
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

  handleNestedFormChange(fieldNs, e) {
    const { target } = e;
    const nestedKey = target.name.replace(fieldNs, '').toLowerCase();
    let nestedValue;

    if (target.type === 'checkbox') {
      nestedValue = target.checked;
    } else {
      nestedValue = target.value;
    }

    const nestedValues = assign({}, this.state.terms[fieldNs], { [nestedKey]: nestedValue });
    this.handleFormChange({ target: { name: fieldNs, value: nestedValues } });
    e.stopPropagation();
  }

  handleCheckboxChange(e) {
    e.stopPropagation();

    if (e.target.checked) {
      this.handleFormChange(e);
    } else {
      const terms = assign({}, this.state.terms, { [e.target.name]: false });
      this.setState({ terms });
    }
  }

  handleFormSubmit(e) {
    e.preventDefault();
    this.setState({ submitting: true });
    this.props.onFormSubmit(this.state.terms);
  }

  getTextFieldList() {
    return [['agreedWith', 'Supplier staff name'],
            ['by', 'Buyers name']];
  }

  setTerms(terms = {}) {
    const appendedTerms = pick(terms, ['season',
                                       ...map(this.getTextFieldList(), '0'),
                                       'samples',
                                       'productImagery']);
    this.setState({ terms: appendedTerms });
  }

  handleFile(files) {
    const self = this;
    const reader = new FileReader();
    const file = files[0];

    reader.onload = function (upload) {
      let terms = self.state.terms;
      terms.confirmation = upload.target.result;
      terms.confirmationFileName = file.name;
      self.setState({ terms: terms });
    };

    reader.readAsDataURL(file);
  }
}
