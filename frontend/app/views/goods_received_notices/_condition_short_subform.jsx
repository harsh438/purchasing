import React from 'react';
import DropZone from 'react-dropzone';

export default class GoodsReceivedNoticesConditionShortSubform extends React.Component {
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
              value="" />
          </div>

          <div className="form-group">
            <label htmlFor="grn_condition_attach_images">
              Attach Images
            </label>

            <DropZone
              multiple
              onDrop={() => {}}
              style={{ color: '#999', padding: '30px', border: '2px dashed #999' }}
              inputProps={{ htmlFor: 'grn_condition_attach_images' }}
              accept=".jpg,.jpeg,.png,.pdf,.eml">
              <div>
                Image(s) displaying the issue. Drag and drop files here, or click to select files to upload.
              </div>
            </DropZone>
          </div>
        </div>
      </div>
    );
  }
}
