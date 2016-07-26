import React from 'react';
import RadioGroup from 'react-radio-group';

export default class GoodsReceivedNoticesConditionFormInput extends React.Component {
  render() {
    const value = this.props.condition[this.props.conditionKey];

    return (
      <section className="grn_condition__item">
        <div className="grn_condition__item_label">{this.props.label}</div>
        <div className="grn_condition__item_options">
          <RadioGroup name={this.props.conditionKey}
                      selectedValue={value.toString()}
                      onChange={() => {}}>
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
      </section>
    );
  }
}
