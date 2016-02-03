import { createStore, combineReducers, applyMiddleware } from 'redux';
import reduceBarcodes from './reducers/barcodes';
import reduceFilters from './reducers/filters';
import reduceGoodsReceivedNotices  from './reducers/goods_received_notices';
import reduceOrder from './reducers/order';
import reduceOrders from './reducers/orders';
import reducePurchaseOrders from './reducers/purchase_orders';
import reduceSkus  from './reducers/skus';
import reduceSuppliers  from './reducers/supplier';
import reduceSupplierTerms from './reducers/supplier_terms';
import reduceVendors  from './reducers/vendor';
import reduceErrorNotification  from './reducers/error_notification';

import thunk from 'redux-thunk';

const middleware = [thunk];

const reducer = combineReducers({ barcodes: reduceBarcodes,
                                  filters: reduceFilters,
                                  goodsReceivedNotices: reduceGoodsReceivedNotices,
                                  order: reduceOrder,
                                  orders: reduceOrders,
                                  purchaseOrders: reducePurchaseOrders,
                                  skus: reduceSkus,
                                  suppliers: reduceSuppliers,
                                  supplierTerms: reduceSupplierTerms,
                                  vendors: reduceVendors,
                                  errorNotification: reduceErrorNotification,
                                  });

const store = applyMiddleware(...middleware)(createStore)(reducer);

export default store;
