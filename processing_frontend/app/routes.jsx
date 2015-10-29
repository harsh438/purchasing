import React from 'react';
import { Route, IndexRoute, NotFoundRoute } from 'react-router';
import Layout from './views/layouts/application';
import Index from './views/purchase_orders/index';

export default (
  <Route path="/" component={Layout}>
    <IndexRoute component={Index} />
  </Route>
);
