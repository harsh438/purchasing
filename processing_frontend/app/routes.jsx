import React from 'react';
import { Route, IndexRoute, NotFoundRoute } from 'react-router';
import Layout from './views/layouts/application';
import PurchaseOrdersIndex from './views/purchase_orders/index';
import OrdersIndex from './views/orders/index';
import OrdersEdit from './views/orders/edit';
import SuppliersIndex from './views/suppliers/index';
import SuppliersNew from './views/suppliers/new';
import SuppliersEdit from './views/suppliers/edit';


export default (
  <Route path="/" component={Layout}>
    <IndexRoute component={PurchaseOrdersIndex} />
    <Route path="/orders" component={OrdersIndex} />
    <Route path="/orders/:id/edit" component={OrdersEdit} />
    <Route path="/suppliers" component={SuppliersIndex} />
    <Route path="/suppliers/new" component={SuppliersNew} />
    <Route path="/suppliers/:id/edit" component={SuppliersEdit} />
  </Route>
);
