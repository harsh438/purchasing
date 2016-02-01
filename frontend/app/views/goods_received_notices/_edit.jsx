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
              <div className="col-xs-12">
                <div className="form-group col-xs-3">
                  <label for="units">Units</label>
                  <input name="units" className="form-control" />
                </div>
                <div className="form-group col-xs-3">
                  <label for="cartons">Cartons</label>
                  <input name="cartons" className="form-control" />
                </div>
                <div className="form-group col-xs-3">
                  <label>Palettes</label>
                  <input name="palettes" className="form-control" />
                </div>
              </div>
            </form>
            <a onClick={this.props.onClose}>close</a>
          </div>
        </div>
      </div>
    );
  }
}
