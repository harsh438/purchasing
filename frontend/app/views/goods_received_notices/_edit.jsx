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

              <div>
                <div className="form-group grn_edit__form_group--purchase_order">
                  <label htmlFor="po">PO #</label>
                  <select name="po" className="form-control"></select>
                </div>

                <div className="form-group grn_edit__form_group--units">
                  <label htmlFor="units">Units</label>
                  <input type="number" name="units" className="form-control" />
                </div>

                <div className="form-group grn_edit__form_group--cartons">
                  <label htmlFor="cartons">Cartons</label>
                  <input type="number" name="cartons" className="form-control" />
                </div>

                <div className="form-group grn_edit__form_group--palettes">
                  <label>Palettes</label>
                  <input type="number" name="palettes" className="form-control" />
                </div>

                <div className="text-right">
                  <button className="btn btn-success">Add</button>
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
