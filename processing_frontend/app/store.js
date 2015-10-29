import { createStore, combineReducers, applyMiddleware } from 'redux';
import reduceFilters from './reducers/filters';
import reducePurchaseOrder from './reducers/purchase_orders';
import thunk from 'redux-thunk';

const middleware = [thunk];

const reducer = combineReducers({ filters: reduceFilters,
                                  purchaseOrders: reducePurchaseOrder });

export default applyMiddleware(...middleware)(createStore)(reducer);
