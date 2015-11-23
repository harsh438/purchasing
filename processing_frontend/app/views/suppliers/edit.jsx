import React from 'react';
import { connect } from 'react-redux';
import { map, assign } from 'lodash';
import SuppliersForm from './_form';
import { loadSupplier } from '../../actions/suppliers';

class SuppliersEdit extends React.Component {
	componentWillMount () {
		this.props.dispatch(loadSupplier(this.props.params.id));
	}

	render() {
    	return (
    		<SuppliersForm submitText="Edit"
  									   supplier={this.props.supplier} />
    	);
  }
}

function applyState({ supplier }) {
  return assign({}, supplier);
}

export default connect(applyState)(SuppliersEdit);
 