import React from 'react';
import ReactDOM from 'react-dom';
import { Router } from 'react-router';
import createHistory from 'history/lib/createBrowserHistory';
import routes from './routes';
import { Provider } from 'react-redux';
import store from './store';

ReactDOM.render((
  <Provider store={store}>
    <Router history={createHistory()}>
      {routes}
    </Router>
  </Provider>
), document.getElementById('app'));
