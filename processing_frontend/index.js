import React from 'react';
import ReactDOM from 'react-dom';
import { Router } from 'react-router';
import createHistory from 'history/lib/createBrowserHistory';
import routes from './routes';

ReactDOM.render((
  <Router history={createHistory()}>
    {routes}
  </Router>
), document.getElementById('app'));
