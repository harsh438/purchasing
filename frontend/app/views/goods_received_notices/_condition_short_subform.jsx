import React from 'react';
import { assign } from 'lodash';
import GoodsReceivedNoticesImageUpload from './_image_upload';

export default class GoodsReceivedNoticesConditionShortSubform extends React.Component {
  componentWillMount() {
    this.props.onChange(this.props.issueType, this.props.issue);
  }

  handleChange({ target }) {
    const updatedIssue = assign({}, this.props.issue, { [target.name]: target.value });
    this.props.onChange(this.props.issueType, updatedIssue);
  }

  handleImageUpload(image) {
    const issue = this.props.issue;
    const updatedIssue = assign({}, issue, {
      goods_received_notice_issue_images: [...issue.goods_received_notice_issue_images, image],
    });

    this.props.onChange(this.props.issueType, updatedIssue);
  }

  render() {
    return (
      <div className="row" style={{ padding: '5px' }}>
        <div className="col-md-6">
          <div className="form-group">
            <label htmlFor="units_affected">
              Units Affected
            </label>

            <input className="form-control"
              name="units_affected"
              step={1}
              type="number"
              placeholder="#"
              value={this.props.issue.units_affected}
              onChange={this.handleChange.bind(this)} />
          </div>

          <div className="form-group">
            <label htmlFor="grn_condition_attach_images">
              Attach Images
            </label>

            <GoodsReceivedNoticesImageUpload
              htmlFor="grn_condition_attach_images"
              onUpload={this.handleImageUpload.bind(this)}
              files={this.props.issue.goods_received_notice_issue_images} />
          </div>
        </div>
      </div>
    );
  }
}
