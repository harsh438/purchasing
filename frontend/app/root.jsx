import React from 'react';
import routes from './routes';
import { Provider } from 'react-redux';
import store from './store';

export default (
  <Provider store={store}>
    {routes}
  </Provider>
);
