import { createStore, combineReducers, applyMiddleware } from 'redux';
import reduceAdvancedMode from './reducers/advanced';
import reduceBarcodes from './reducers/barcodes';
import reduceNotification  from './reducers/notification';
import reduceFilters from './reducers/filters';
import reduceGoodsReceivedNotices  from './reducers/goods_received_notices';
import reduceOrder from './reducers/order';
import reduceOrders from './reducers/orders';
import reducePackingLists from './reducers/packing_lists';
import reducePurchaseOrders from './reducers/purchase_orders';
import reduceSkus  from './reducers/skus';
import reduceSuppliers  from './reducers/supplier';
import reduceSupplierTerms from './reducers/supplier_terms';
import reduceUsers  from './reducers/users';
import reduceVendors  from './reducers/vendor';
import reduceElements from './reducers/elements';
import reduceRefusedDeliveriesLogs from './reducers/refused_deliveries_logs';

import thunk from 'redux-thunk';

const middleware = [thunk];

const reducer = combineReducers({ advanced: reduceAdvancedMode,
                                  barcodes: reduceBarcodes,
                                  notification: reduceNotification,
                                  filters: reduceFilters,
                                  goodsReceivedNotices: reduceGoodsReceivedNotices,
                                  order: reduceOrder,
                                  orders: reduceOrders,
                                  packingLists: reducePackingLists,
                                  purchaseOrders: reducePurchaseOrders,
                                  skus: reduceSkus,
                                  suppliers: reduceSuppliers,
                                  supplierTerms: reduceSupplierTerms,
                                  users: reduceUsers,
                                  vendors: reduceVendors,
                                  elements: reduceElements,
                                  refusedDeliveriesLogs: reduceRefusedDeliveriesLogs,
                                });

const store = applyMiddleware(...middleware)(createStore)(reducer);
window.store = store;
export default store;
