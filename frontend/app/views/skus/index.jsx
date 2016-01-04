import React from 'react';
import { Link } from 'react-router';
import { connect } from 'react-redux';
import { assign, isEqual } from 'lodash';
import { loadSkus } from '../../actions/skus';

class SkusIndex extends React.Component {
  componentWillMount() {
    this.loadPage();
  }

  render() {
    return (
      <div className="suppliers_index container-fluid"
           style={{ marginTop: '70px' }}>
        <div className="row" style={{ marginBottom: '20px' }}>
          <div className="col-md-4">
            <h1>SKUs</h1>
          </div>
        </div>
      </div>
    );
  }

  loadPage(page = this.props.location.query.page, filters = this.props.location.query.filters) {
    this.props.dispatch(loadSkus({ filters, page }));
  }
}

function applyState({ filters, skus }) {
  return assign({}, filters, skus);
}

export default connect(applyState)(SkusIndex);
