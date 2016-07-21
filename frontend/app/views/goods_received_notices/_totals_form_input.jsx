import React from 'react';

export default class GoodsReceivedNoticesTotalsFormInput extends React.Component {
  render() {
    return (
      <div className="form-group">
        <div className="row">
          <div className="col-md-6">
            <label htmlFor={this.props.htmlId}>
              {this.props.title}
            </label>
          </div>

          <div className="col-md-6 text-right">
            <input className="form-control"
              id={this.props.htmlId}
              name={this.props.htmlName}
              onChange={this.props.onChange.bind(this)}
              step={this.props.step}
              type="number"
              value={this.props.value}
              required />
          </div>
        </div>
      </div>
    );
  }
}

GoodsReceivedNoticesTotalsFormInput.defaultProps = {
  step: "0.0001",
};
