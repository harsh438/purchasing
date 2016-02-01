import React from 'react';

export default class GoodsReceivedNoticesEdit extends React.Component {
  render() {
    return (
      <div className="grn_edit">
        <div className="panel panel-default">
          <div className="panel-heading">
            <h3 className="panel-title">GRN #0004</h3>
          </div>

          <div className="panel-body">
            <form>
              <div className="form-group">
                <select className="form-control">
                  <option>Nike</option>
                </select>
              </div>
            </form>

            <a onClick={this.props.onClose}>close</a>
          </div>
        </div>
      </div>
    );
  }
}
