import React from 'react';
import DropZone from 'react-dropzone';
import { assign, get, map, omit, startCase, pick } from 'lodash';
import { Link } from 'react-router';

export default class SuppliersForm extends React.Component {
  componentWillMount() {
    this.state = { submitting: false};
    this.setTerms(this.props.terms);
  }

  componentWillReceiveProps(nextProps) {
    this.setState({ submitting: false });
    // the file has to be re-uploaded every time anyway
    this.setTerms(nextProps.terms);
  }

  getTextFieldList() {
    return [['creditLimit', ''],
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
            ['by', 'Buyers name']];
  }

  setTerms(terms = {}) {
    this.state.terms = pick(terms,  ['season'].concat(map(this.getTextFieldList(), '0')));
    this.setState({ terms: this.state.terms });
  }

  handleFile(files) {
    var self = this;
    var reader = new FileReader();
    var file = files[0];

    reader.onload = function(upload) {
      let terms = self.state.terms;
      terms.confirmation = upload.target.result;
      terms.confirmationFileName = file.name;
      self.setState({ terms: terms });
    }

    reader.readAsDataURL(file);
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
              <td colSpan="2">
                <div>
                  <DropZone multiple={false}
                            onDrop={this.handleFile.bind(this)}
                            style={{ color: '#999', padding: '30px', border: '2px dashed #999' }}
                            accept=".jpg,.jpeg,.png,.pdf">
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
      return (<div style={ {margin: '5px 10px 0 10px'} }>
            <span className="glyphicon glyphicon-open-file"></span>
            <span style={{'color':'grey'}}> File to upload: {this.state.terms.confirmationFileName}</span>
          </div>
      );
    }
  }

  renderTextFields() {
    return map(this.getTextFieldList(),
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

    this.state.terms[e.target.name] = '' + (0+e.target.checked);
    this.setState({ terms: this.state.terms });
  }

  handleFormSubmit(e) {
    e.preventDefault();
    this.setState({ submitting: true });
    this.props.onFormSubmit(this.state.terms);
  }
}
