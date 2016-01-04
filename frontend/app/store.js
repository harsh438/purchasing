import { createStore, combineReducers, applyMiddleware } from 'redux';
import reduceFilters from './reducers/filters';
import reducePurchaseOrders from './reducers/purchase_orders';
import reduceOrders from './reducers/orders';
import reduceOrder from './reducers/order';
import { reduceSuppliers, reduceSupplier }  from './reducers/supplier';
import { reduceSupplierTerms, reduceTerms }  from './reducers/supplier_terms';
import reduceSkus  from './reducers/skus';
import { reduceVendor, reduceVendors }  from './reducers/vendor';
import reduceGoodsReceivedNotices  from './reducers/goods_received_notices';

import thunk from 'redux-thunk';

const middleware = [thunk];

const reducer = combineReducers({ filters: reduceFilters,
                                  orders: reduceOrders,
                                  order: reduceOrder,
                                  purchaseOrders: reducePurchaseOrders,
                                  suppliers: reduceSuppliers,
                                  supplier: reduceSupplier,
                                  skus: reduceSkus,
                                  vendors: reduceVendors,
                                  vendor: reduceVendor,
                                  supplierTerms: reduceSupplierTerms,
                                  terms: reduceTerms,
                                  goodsReceivedNotices: reduceGoodsReceivedNotices });

const store = applyMiddleware(...middleware)(createStore)(reducer);

export default store;
