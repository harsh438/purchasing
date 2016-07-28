import React from 'react';
import RadioGroup from 'react-radio-group';
import GoodsReceivedNoticesConditionShortSubform from './_condition_short_subform';

export default class GoodsReceivedNoticesConditionFormInput extends React.Component {
  renderSubform() {
    return (
      <GoodsReceivedNoticesConditionShortSubform
        onChange={this.props.onSubformChange.bind(this)}
        issue={this.props.issue}
        issueType={this.props.issueType} />
    );
  }

  render() {
    const showSubform = this.props.hasSubform && !this.props.value;

    return (
      <section className="grn_condition__item">
        <div className="grn_condition__item_label">{this.props.label}</div>
        <div className="grn_condition__item_options">
          <RadioGroup name={this.props.issueType}
                      selectedValue={this.props.value.toString()}
                      onChange={this.props.onChange.bind(this)}>
            {Radio => (
              <div className="form-group" style={{ margin: 0 }}>
                <label className="status-label">
                  <Radio value="1" /> Yes
                </label>
                <label className="status-label">
                  <Radio value="0" /> No
                </label>
              </div>
            )}
          </RadioGroup>
        </div>
        {showSubform && this.renderSubform()}
      </section>
    );
  }
}
