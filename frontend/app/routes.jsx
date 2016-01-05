import React from 'react';
import { Route, IndexRoute, NotFoundRoute } from 'react-router';
import Layout from './views/layouts/application';
import PurchaseOrderLineItemsIndex from './views/purchase_order_line_items/index';
import OrdersIndex from './views/orders/index';
import OrdersEdit from './views/orders/edit';
import SuppliersIndex from './views/suppliers/index';
import SuppliersNew from './views/suppliers/new';
import SuppliersEdit from './views/suppliers/edit';
import SupplierTermsHistory from './views/supplier_terms/history';
import SupplierTermsShow from './views/supplier_terms/show';
import SuppliersTermsIndex from './views/supplier_terms/index';
import VendorsIndex from './views/vendors/index';
import VendorsEdit from './views/vendors/edit';
import VendorsNew from './views/vendors/new';
import GoodsReceivedNoticesIndex from './views/goods_received_notices/index';
import SkusIndex from './views/skus/index';
import SkusEdit from './views/skus/edit';

export default (
  <Route path="/" component={Layout}>
    <Route path="/skus" component={SkusIndex} />
    <Route path="/skus/:id/edit" component={SkusEdit} />

    <Route path="/orders" component={OrdersIndex} />
    <Route path="/orders/:id/edit" component={OrdersEdit} />

    <Route path="/orders" component={OrdersIndex} />
    <IndexRoute component={PurchaseOrderLineItemsIndex} />

    <Route path="/suppliers" component={SuppliersIndex} />
    <Route path="/suppliers/new" component={SuppliersNew} />
    <Route path="/suppliers/:id/edit" component={SuppliersEdit} />
    <Route path="/suppliers/:id/terms" component={SupplierTermsHistory} />
    <Route path="/suppliers/term/:id" component={SupplierTermsShow} />

    <Route path="/vendors" component={VendorsIndex} />
    <Route path="/vendors/new" component={VendorsNew} />
    <Route path="/vendors/:id/edit" component={VendorsEdit} />

    <Route path="/terms" component={SuppliersTermsIndex} />

    <Route path="/goods-received-notices" component={GoodsReceivedNoticesIndex} />
  </Route>
);
