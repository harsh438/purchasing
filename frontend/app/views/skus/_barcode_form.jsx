import React from 'react';

export default class SkusBarcodeForm extends React.Component {
  componentWillMount() {
    this.state = { submitting: false };
  }

  componentWillReceiveProps(nextProps) {
    this.setState({ submitting: false });
  }

  render() {
    return (
      <div className="panel panel-default">
        <div className="panel-heading">
          <h3 className="panel-title">Add Barcode to SKU</h3>
        </div>

        <div className="panel-body">
          <form className="form"
                onChange={this.handleFormChange.bind(this)}
                onSubmit={this.handleFormSubmit.bind(this)}>
            <table className="table">
              <tbody>
                <tr>
                  <td>
                    <label htmlFor="barcode">Barcode</label>
                  </td>
                  <td>
                    <input className="form-control"
                           id="barcode"
                           name="barcode"
                           value={this.state.barcode} />
                  </td>
                </tr>
              </tbody>
            </table>

            <button className="btn btn-success"
                    disabled={this.state.submitting}>
              {this.submitText()}
            </button>
          </form>
        </div>
      </div>
    );
  }

  submitText() {
    if (this.state.submitting) {
      return 'Adding barcode...';
    } else {
      return 'Add barcode';
    }
  }

  handleFormChange({ target }) {
    this.setState({ [target.name]: target.value });
  }

  handleFormSubmit(e) {
    e.preventDefault();
    this.setState({ submitting: true });
    this.props.onAddBarcode(this.state.barcode);
  }
}
