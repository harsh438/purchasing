import React from 'react';
import { connect } from 'react-redux';
import Filters from './_filters';
import Table from './_table';

export default class PackingListsIndex extends React.Component {
  render() {
    return (
      <div className="suppliers_index container-fluid"
           style={{ marginTop: '70px' }}>
        <div className="row" style={{ marginBottom: '20px' }}>
          <div className="col-md-4">
            <h1>Packing lists</h1>
          </div>
        </div>

        <div className="row">
          <div className="col-md-12">
            <Filters />
            <Table />
          </div>
        </div>
      </div>
    );
  }
}
