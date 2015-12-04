import React from 'react';
import { map } from 'lodash';
import { assign } from 'lodash';
import SupplierBuyersForm from './_form';
import { addSupplierBuyer } from '../../actions/suppliers';

export default class SupplierBuyersTable extends React.Component {
  componentWillMount() {
    this.state = { addingBuyer: false, editingBuyer: false };
  }

  componentWillReceiveProps(nextProps) {
    this.setState({ addingBuyer: false, editingBuyer: false });
  }

  render() {
    return (
      <div>
        {this.renderBuyerAdd()}
        {this.renderBuyers()}
      </div>
    );
  }

  renderBuyerAdd() {
    if (this.state.addingBuyer) {
      return (
        <div className="panel panel-default">
          <div className="panel-heading">
            <h3 className="panel-title">Add Buyer</h3>
          </div>
          <div className="panel-body">
            <SupplierBuyersForm submitText="Add buyer"
                                submittingText="Adding buyer..."
                                buyer={{}}
                                onFormSubmit={this.props.onBuyerAdd} />
          </div>
        </div>
      );
    } else {
      return (
        <div className="panel panel-default">
          <div className="panel-heading">
            <h3 className="panel-title">Buyers</h3>
          </div>
          <div className="panel-body">
            <div style={{ marginBottom: '10px'}}>
              {this.renderBuyersText()}

              <button className="btn btn-success"
                      onClick={() => this.setState({ addingBuyer: true })}>
                Add new buyer
              </button>
            </div>
          </div>
        </div>
      );
    }
  }

  renderBuyers() {
    return map(this.props.supplier.buyers, (buyer, i) => {
      return (
        <li style={{ listStyleType: 'none' }} key={buyer.id}>
          <div className="panel panel-default">
            <div className="panel-body">
              {this.renderBuyer(buyer)}
            </div>
          </div>
        </li>
      );
    });
  }

  renderBuyer(buyer) {
    if (this.state.editingBuyer === buyer.id) {
      return (
        <SupplierBuyersForm submitText="Save buyer"
                            submittingText="Saving buyer..."
                            buyer={buyer}
                            onFormSubmit={this.props.onBuyerEdit} />
      );
    }

    return (
      <div>
        <table className="table" style={{ tableLayout: 'fixed' }}>
          <tbody>
            <tr>
              <th>Buyer name</th>
              <td>{buyer.buyerName}</td>

              <th>Assistant name</th>
              <td>{buyer.assistantName}</td>
            </tr>

            <tr>
              <th>Department</th>
              <td>{buyer.department}</td>

              <th>Business unit</th>
              <td>{buyer.businessUnit}</td>
            </tr>
          </tbody>
        </table>

        <button className="btn btn-success"
                onClick={() => this.setState({ editingBuyer: buyer.id })}>
          Edit buyer
        </button>
      </div>
    );
  }

  renderBuyersText() {
    if (this.props.supplier.buyers.length === 0) {
      return (
        <p>
          <em>No buyers for this supplier</em>
        </p>
      );
    }
  }
}
