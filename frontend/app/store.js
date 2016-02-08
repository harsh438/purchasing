import { createStore, combineReducers, applyMiddleware } from 'redux';
import reduceAdvancedMode from './reducers/advanced';
import reduceBarcodes from './reducers/barcodes';
import reduceErrorNotification  from './reducers/error_notification';
import reduceFilters from './reducers/filters';
import reduceGoodsReceivedNotices  from './reducers/goods_received_notices';
import reduceOrder from './reducers/order';
import reduceOrders from './reducers/orders';
import reducePackingLists from './reducers/packing_lists';
import reducePurchaseOrders from './reducers/purchase_orders';
import reduceSkus  from './reducers/skus';
import reduceSuppliers  from './reducers/supplier';
import reduceSupplierTerms from './reducers/supplier_terms';
import reduceVendors  from './reducers/vendor';

import thunk from 'redux-thunk';

const middleware = [thunk];

const reducer = combineReducers({ advanced: reduceAdvancedMode,
                                  barcodes: reduceBarcodes,
                                  errorNotification: reduceErrorNotification,
                                  filters: reduceFilters,
                                  goodsReceivedNotices: reduceGoodsReceivedNotices,
                                  order: reduceOrder,
                                  orders: reduceOrders,
                                  packingLists: reducePackingLists,
                                  purchaseOrders: reducePurchaseOrders,
                                  skus: reduceSkus,
                                  suppliers: reduceSuppliers,
                                  supplierTerms: reduceSupplierTerms,
                                  vendors: reduceVendors });

const store = applyMiddleware(...middleware)(createStore)(reducer);
window.store = store;
export default store;
