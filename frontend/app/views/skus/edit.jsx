import React from 'react';
import { connect } from 'react-redux';
import { Link } from 'react-router';
import { assign } from 'lodash';
import { loadSku } from '../../actions/skus';

class SkusEdit extends React.Component {
  componentWillMount () {
    this.props.dispatch(loadSku(this.props.params.id));
  }

  render() {
    return (
      <div className="skus_edit container-fluid" style={{ marginTop: '70px' }}>
        <div className="row" style={{ marginBottom: '20px' }}>
          <div className="col-md-6">
            <h1>
              <Link to="/suppliers">SKUs</Link>
              &nbsp;/&nbsp;
              {this.props.sku.sku}
            </h1>
          </div>
        </div>
      </div>
    );
  }
}

function applyState({ filters, skus, sku }) {
  return assign({}, filters, skus);
}

export default connect(applyState)(SkusEdit);
