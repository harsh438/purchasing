import { createStore, combineReducers, applyMiddleware } from 'redux';
import reduceFilters from './reducers/filters';
import reducePurchaseOrder from './reducers/purchase_orders';
import thunk from 'redux-thunk';

const middleware = [thunk];

const reducer = combineReducers({ filters: reduceFilters,
                                  purchaseOrders: reducePurchaseOrder });

const store = applyMiddleware(...middleware)(createStore)(reducer);

export default store;
