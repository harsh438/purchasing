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
        <SupplierBuyersForm submitText="Add buyer"
                            submittingText="Adding buyer..."
                            buyer={{}}
                            onFormSubmit={this.props.onBuyerAdd} />
      );
    } else {
      return (
        <div className="clearfix"
             style={{ marginBottom: '10px' }}>
          {this.renderBuyersText()}

          <button className="btn btn-success pull-right"
                  onClick={() => this.setState({ addingBuyer: true })}>
            Add new buyer
          </button>
        </div>
      );
    }
  }

  renderBuyers() {
    if (this.state.addingBuyer) return;

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
    if (this.state.addingBuyer) return;

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
        <table className="table table-hover" style={{ tableLayout: 'fixed' }}>
          <tbody>
            <tr>
              <th style={{ width: '22%' }}>Buyer name</th>
              <td>{buyer.buyerName}</td>

              <th style={{ width: '22%' }}>Assistant name</th>
              <td>{buyer.assistantName}</td>
            </tr>

            <tr>
              <th style={{ width: '22%' }}>Department</th>
              <td>{buyer.department}</td>

              <th style={{ width: '22%' }}>Business unit</th>
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
        <p className="pull-left">
          <em>No buyers for this supplier</em>
        </p>
      );
    }
  }
}
