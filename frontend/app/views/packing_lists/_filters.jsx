import React from 'react';

export default class PackingListsFilters extends React.Component {
  componentWillMount() {
    this.state = { submitting: false };
  }

  componentWillReceiveProps() {
    this.setState({ submitting: false });
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
                <button className="btn btn-default">Today</button>
                &nbsp;
                <button className="btn btn-default">Tomorrow</button>
              </div>

              <div className="col-md-2 form-group">
                <label htmlFor="startDate">From</label>

                <input className="form-control"
                       name="startDate"
                       id="startDate"
                       type="date"
                       value={this.state.startDate} />
              </div>

              <div className="col-md-2 form-group">
                <label htmlFor="endDate">To</label>

                <input className="form-control"
                       name="endDate"
                       id="endDate"
                       type="date"
                       value={this.state.endDate} />
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

  handleChange({ target }) {
    this.setState({ [target.name]: target.value });
  }

  handleSubmit(e) {
    e.preventDefault();
    this.setState({ submitting: true });
    this.props.onSubmit(this.state);
  }
}
