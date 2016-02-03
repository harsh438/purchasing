import React from 'react';

export default class GoodsReceivedNoticesEdit extends React.Component {
  componentWillMount() {
    this.state = {};
  }

  render() {
    return (
      <div className="grn_edit">
        <div className="panel panel-default panel-info">
          <div className="panel-heading">
            <h3 className="panel-title">
              GRN #{this.props.goodsReceivedNotice.id}
              &nbsp;–&nbsp;
              {this.props.goodsReceivedNotice.deliveryDate}
            </h3>
          </div>

          <div className="panel-body">
            <form onChange={this.handleChange.bind(this)}
                  onSubmit={this.handleSubmit.bind(this)}>
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

                <div className="form-group grn_edit__form_group--pallets">
                  <label>Palettes</label>
                  <input type="number" name="pallets" className="form-control" />
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

  handleChange({ target }) {
    this.setState({ [target.name]: target.value });
  }

  handleSubmit(e) {
    e.preventDefault();
    this.props.onSave(this.state);
  }
}
