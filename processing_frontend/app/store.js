import { createStore, combineReducers, applyMiddleware } from 'redux';
import reduceFilters from './reducers/filters';
import reducePurchaseOrders from './reducers/purchase_orders';
import reduceOrders from './reducers/orders';
import reduceOrder from './reducers/order';
import { reduceSuppliers, reduceSupplier }  from './reducers/supplier';
import { reduceVendor }  from './reducers/vendor';

import thunk from 'redux-thunk';

const middleware = [thunk];

const reducer = combineReducers({ filters: reduceFilters,
                                  orders: reduceOrders,
                                  order: reduceOrder,
                                  purchaseOrders: reducePurchaseOrders,
                                  suppliers: reduceSuppliers,
                                  supplier: reduceSupplier,
                                  vendor: reduceVendor });

const store = applyMiddleware(...middleware)(createStore)(reducer);

export default store;
