import React from 'react';
import RadioGroup from 'react-radio-group';

export default class GoodsReceivedNoticesConditionFormInput extends React.Component {
  render() {
    const value = this.props.condition[this.props.conditionKey].toString();

    return (
      <tr>
        <td colSpan="3">{this.props.label}</td>
        <td colSpan="3">
          <RadioGroup name={this.props.conditionKey}
                      selectedValue={value}
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
        </td>
      </tr>
    );
  }
}
