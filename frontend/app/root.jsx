import React from 'react';
import { Router } from 'react-router';
import createHistory from 'history/lib/createHashHistory';
import routes from './routes';
import { Provider } from 'react-redux';
import store from './store';

export default (
  <Provider store={store}>
    <Router history={createHistory()}>
      {routes}
    </Router>
  </Provider>
);
