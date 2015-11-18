import React from 'react';
import { map, range } from 'lodash';

function getMonday(d) {
  d = new Date(d);
  let day = d.getDay(), diff = d.getDate() - day + (day == 0 ? -6:1);
  return new Date(d.setDate(diff));
}

export function dropDates() {
  return map(range(52), (n) => {
    let date = new Date()
    date.setDate(date.getDate() + (n * 7))
    date = getMonday(date);
    return { value: date.toISOString().slice(0,10), label: date.toDateString() }
  });
}

export class WeekSelect extends React.Component {
  componentWillMount() {
    this.setState({ dropDate: dropDates()[0].value })
  }

  render() {
    return (
      <div className="form-group col-md-2">
        <label htmlFor="dropDate">Drop Date</label>
        <select name="dropDate"
                ref="dropDate"
                onChange={this.handleChange.bind(this)}
                className="form-control"
                required="required"
                value={this.state.dropDate}>
          {this.renderOptions()}
        </select>
      </div>
    );
  }

  renderOptions() {
    return map(dropDates(), (date) => {
      return (
        <option key={date.value} value={date.value}>{date.label}</option>
      );
    });
  }

  handleChange() {
    this.setState({ dropDate: this.refs.dropDate.value })
  }
}
