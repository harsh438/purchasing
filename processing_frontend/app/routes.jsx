import React from 'react';
import { Route, IndexRoute, NotFoundRoute } from 'react-router';
import Layout from './views/layouts/application';
import PurchaseOrdersIndex from './views/purchase_orders/index';
import OrdersIndex from './views/orders/index';

export default (
  <Route path="/" component={Layout}>
    <IndexRoute component={PurchaseOrdersIndex} />
    <Route path="/orders" component={OrdersIndex} />
  </Route>
);
