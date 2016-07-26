import React from 'react';
import GoodsReceivedNoticesImageUpload from './_image_upload';

export default class GoodsReceivedNoticesConditionShortSubform extends React.Component {
  componentWillMount() {
    this.state = { files: [] };
  }

  handleImage(image) {
    this.setState({ files: [...this.state.files, image] });
  }

  render() {
    return (
      <div className="row" style={{ padding: '5px' }}>
        <div className="col-md-6">
          <div className="form-group">
            <label htmlFor="grn_condition_units_affected">
              Units Affected
            </label>

            <input className="form-control"
              name="grn_condition_units_affected"
              step={1}
              type="number"
              placeholder="#"
              value={this.props.unitsAffected} />
          </div>

          <div className="form-group">
            <label htmlFor="grn_condition_attach_images">
              Attach Images
            </label>

            <GoodsReceivedNoticesImageUpload
              htmlFor="grn_condition_attach_images"
              onUpload={this.handleImage.bind(this)}
              files={this.state.files} />
          </div>
        </div>
      </div>
    );
  }
}
