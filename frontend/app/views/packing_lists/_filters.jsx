import React from 'react';
import moment from 'moment';

export default class PackingListsFilters extends React.Component {
  componentWillMount() {
    this.state = { submitting: false, ...this.props.filters };
  }

  componentWillReceiveProps(nextProps) {
    this.setState({ submitting: false, ...nextProps.filters });
  }

  render() {
    return (
      <div className="panel panel-default">
        <div className="panel-body">
          <form onChange={this.handleChange.bind(this)}
                onSubmit={this.handleSubmit.bind(this)}>
            <div className="row no_gutter">
              <div className="col-md-2"
                   style={{ marginTop: '1.8em' }}>
                <button className="btn btn-default"
                        onClick={this.handleToday.bind(this)}>Today</button>
                &nbsp;
                <button className="btn btn-default"
                        onClick={this.handleTomorrow.bind(this)}>Tomorrow</button>
              </div>

              <div className="col-md-2 form-group">
                <label htmlFor="startDate">From</label>

                <input className="form-control"
                       name="dateFrom"
                       id="startDate"
                       type="date"
                       value={this.state.dateFrom} />
              </div>

              <div className="col-md-2 form-group">
                <label htmlFor="endDate">To</label>

                <input className="form-control"
                       name="dateTo"
                       id="endDate"
                       type="date"
                       value={this.state.dateTo} />
              </div>

              <div className="col-md-2 btn-group"
                    style={{ marginTop: '1.8em' }}>
                <button className="btn btn-primary"
                        disabled={this.state.submitting}
                        style={{ width: '70%' }}>
                  {this.submitText()}
                </button>
              </div>
            </div>
          </form>
        </div>
      </div>
    );
  }

  submitText() {
    if (this.state.submitting) {
      return 'Searching...';
    } else {
      return 'Search';
    }
  }

  handleToday(e) {
    const today = moment().format('YYYY-MM-DD');
    this.setState({ dateFrom: today, dateTo: today }, () => this.handleSubmit(e));
  }

  handleTomorrow(e) {
    const tomorrow = moment().add({ days: 1 }).format('YYYY-MM-DD');
    this.setState({ dateFrom: tomorrow, dateTo: tomorrow }, () => this.handleSubmit(e));
  }

  handleChange({ target }) {
    this.setState({ [target.name]: target.value });
  }

  handleSubmit(e) {
    e.preventDefault();
    this.setState({ submitting: true });
    this.props.onSubmit(this.state);
  }
}
