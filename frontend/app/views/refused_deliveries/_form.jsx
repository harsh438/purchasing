import React from 'react';
import DropZone from 'react-dropzone';
import Select from 'react-select';
import moment from 'moment';
import { assign, omit, get, map, filter, clone } from 'lodash';
import { camelizeKeys } from '../../utilities/inspection';
import { renderSelectOptions,
         renderMultiSelectOptions } from '../../utilities/dom';

export default class RefusedDeliveriesForm extends React.Component {
  componentWillMount() {
    const deliveryDate = moment().format('YYYY-MM-DD');
    this.state = assign({ deliveryDate, submitting: false, files: [] }, this.props.refusedDelivery);
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
            <tr>
                <td><label htmlFor="refusalReason">Reason for refusal</label></td>
                <td>
                  <DropZone multiple
                            onDrop={this.handleFile.bind(this)}
                            style={{ color: '#999', padding: '30px', border: '2px dashed #999' }}
                            accept=".jpg,.jpeg,.png,.pdf,.eml">
                    <div>Confirmation file for the terms. Try dropping some files here, or click to select files to upload.</div>
                  </DropZone>
                  {this.renderFileUploadText()}
                </td>
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

  renderFileUploadText() {
    if (this.state.files.length) {
      return this.state.files.map(this.renderFileUploadPreview.bind(this));
    }
  }

  renderFileUploadPreview(file) {
    return (
      <div style={{ margin: '5px 10px 0 10px' }}>
        <span className="glyphicon glyphicon-remove"
              onClick={this.removeFileUpload.bind(this, file)}
              style={{ cursor: 'pointer' }}></span>
        &nbsp;
        <span className="glyphicon glyphicon-open-file"></span>
        <span style={{ color: 'grey' }}>File to upload: {file.imageFileName}</span>
        <img height="50" src={file.preview} />
      </div>
    );
  }

  removeFileUpload(file) {
    this.setState({ files: filter(this.state.files, ({ imageFileName }) =>  file.imageFileName !== imageFileName) });
  }

  handleFile(files) {
    const self = this;
    files.forEach((file) => {
      const reader = new FileReader();

      reader.onload = (upload) => {
        let image = {};
        image.image = upload.target.result;
        image.imageFileName = file.name;
        image.preview = file.preview;
        self.setState({ files: self.state.files.concat(image) });
      };

      reader.readAsDataURL(file);
    });
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

  handleFormSubmit(e) {
    e.preventDefault();
    let refusedDelivery = clone(this.state);

    this.setState({ submitting: true });

    refusedDelivery.files.forEach((file) => delete file.preview);
    refusedDelivery.refusedDeliveriesLogImagesAttributes = refusedDelivery.files;
    delete refusedDelivery.files;
    this.props.onSubmitRefusedDelivery(refusedDelivery);
  }
}
