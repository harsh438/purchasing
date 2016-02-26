import React from 'react';
import { connect } from 'react-redux';

class SkusNew extends React.Component {
  render() {
    return (<div className="skus_new container-fluid application-root-container">
    </div>)
  }
}

function applyState({ suppliers }) {
  return suppliers;
}

export default connect(applyState)(SkusNew);
