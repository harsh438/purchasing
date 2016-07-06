import React from 'react';
import moment from 'moment';

export default class RefusedDeliveriesLogsFilters extends React.Component {
  componentWillMount() {
    this.state = { submitting: false };
    this.ensureFilters();
  }

  componentWillReceiveProps(nextProps) {
    this.setState({ submitting: false });
    this.ensureFilters(nextProps);
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

  ensureFilters({ filters } = this.props) {
    const { dateFrom, dateTo } = filters;

    if (!dateFrom || !dateTo) {
      this.handleToday();
    } else {
      this.setState({ dateFrom, dateTo });
    }
  }

  handleToday(e) {
    if (e) e.preventDefault();
    const today = moment().format('YYYY-MM-DD');
    this.setState({ dateFrom: today, dateTo: today }, this.handleSubmit.bind(this));
  }

  handleTomorrow(e) {
    e.preventDefault();
    const tomorrow = moment().add({ days: 1 }).format('YYYY-MM-DD');
    this.setState({ dateFrom: tomorrow, dateTo: tomorrow }, this.handleSubmit.bind(this));
  }

  handleChange({ target }) {
    this.setState({ [target.name]: target.value });
  }

  handleSubmit(e) {
    if (e) e.preventDefault();
    this.setState({ submitting: true });
    this.props.onSubmit(this.state);
  }
}
