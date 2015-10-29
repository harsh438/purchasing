import { createStore, combineReducers, applyMiddleware } from 'redux';
import reducePurchaseOrder from './reducers/purchase_orders';
import reduceBrands from './reducers/brands';
import thunk from 'redux-thunk';

const middleware = [thunk];

const reducer = combineReducers({ brands: reduceBrands,
                                  purchaseOrders: reducePurchaseOrder });

export default applyMiddleware(...middleware)(createStore)(reducer);
