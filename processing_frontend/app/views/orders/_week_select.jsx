import React from 'react';
import { map, range } from 'lodash';

export function dropDates() {
  return map(range(52), (n) => {
    let date = new Date()
    date.setDate(date.getDate() + (n * 7))
    date = this.getMonday(date);
    return { value: date.toISOString().slice(0,10), label: date.toDateString() }
  });
}

export default class WeekSelect extends React.Component {
  componentWillMount() {
    this.props.table.setState({ dropDate: dropDates()[0].value })
  }

  render() {
    return (
      <div className="form-group col-md-2">
        <label htmlFor="dropDate">Drop Date</label>
        <select name="dropDate"
                ref="dropDate"
                onChange={this.handleChange.bind(this, 'dropDate')}
                className="form-control"
                required="required"
                value={this.props.table.state.dropDate}>
          {this.renderOptions()}
        </select>
      </div>
    );
  }

  renderOptions() {
    return map(dropDates(), (date) => {
      return (
        <option value={date.value}>{date.label}</option>
      );
    });
  }

  handleChange (field, { target }) {
    this.props.table.setState({ dropDate: this.refs.dropDate.value })
  }

  getMonday(d) {
    d = new Date(d);
    let day = d.getDay(), diff = d.getDate() - day + (day == 0 ? -6:1);
    return new Date(d.setDate(diff));
  }
}
