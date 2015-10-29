import { createStore, combineReducers, applyMiddleware } from 'redux';
import reducePurchaseOrder from './reducers/purchase_orders';
import thunk from 'redux-thunk';

const middleware = [thunk];

const reducer = combineReducers({ purchaseOrders: reducePurchaseOrder });

export default applyMiddleware(...middleware)(createStore)(reducer);
