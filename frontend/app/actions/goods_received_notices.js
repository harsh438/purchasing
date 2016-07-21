import Qs from 'qs';
import moment from 'moment';

function throw404Error(response) {
  if (response.status === 404) {
    throw "404";
  } else {
    return response;
  }
}

export function loadGoodsReceivedNotice(id) {
  return dispatch => {
    fetch(`/api/goods_received_notices/${id}.json`, { credentials: 'same-origin' })
      .then(throw404Error)
      .then(response => response.json())
      .then(function (goodsReceivedNotice) {
        dispatch({ goodsReceivedNotice, type: 'SET_GOODS_RECEIVED_NOTICE' });
      })
      .catch(() => {
        dispatch({ text: `Unable to find GRN ${id}`, type: 'ERROR_NOTIFICATION' });
      });
  };
}

function weekStartDate(middleWeekStart) {
  return moment(middleWeekStart, 'DD/MM/YYYY').startOf('isoWeek');
}

export function loadGoodsReceivedNotices(middleWeekStart, purchaseOrderId) {
  const startDate = weekStartDate(middleWeekStart).subtract(2, 'weeks').format('YYYY-MM-DD');
  const endDate = weekStartDate(middleWeekStart).add({ weeks: 2, days: 4 }).format('YYYY-MM-DD');

  return dispatch => {
    const queryString = Qs.stringify({ start_date: startDate,
                                       end_date: endDate,
                                       purchase_order_id: purchaseOrderId });

    fetch(`/api/goods_received_notices.json?${queryString}`, { credentials: 'same-origin' })
      .then(response => response.json())
      .then(goodsReceivedNotices => dispatch({ goodsReceivedNotices, type: 'SET_GOODS_RECEIVED_NOTICES' }));
  };
}

export function createGoodsReceivedNotice({ currentDate, deliveryDate }) {
  return dispatch => {
    const formattedDeliveryDate = moment(deliveryDate, 'DD/MM/YYYY').format('YYYY-MM-DD');
    const goodsReceivedNotice = { goods_received_notice: { delivery_date: formattedDeliveryDate } };

    fetch('/api/goods_received_notices.json', { credentials: 'same-origin',
                                                method: 'post',
                                                headers: { 'Content-Type': 'application/json' },
                                                body: JSON.stringify(goodsReceivedNotice) })
      .then(response => response.json())
      .then(function (goodsReceivedNotice) {
        dispatch({ goodsReceivedNotice, type: 'SET_GOODS_RECEIVED_NOTICE' });
        dispatch(loadGoodsReceivedNotices(goodsReceivedNotice.delivery_date));
      });
  };
}

function updateGrn(id, body, currentDate) {
  return dispatch => {
    fetch(`/api/goods_received_notices/${id}.json`, { credentials: 'same-origin',
                                                      method: 'PATCH',
                                                      headers: { 'Content-Type': 'application/json' },
                                                      body: JSON.stringify(body) })
      .then((response) => {
        if (response.status === 422) {
          dispatch({ text: 'The file uploaded is of an invalid type, the packing file will not be stored.', type: 'ERROR_NOTIFICATION' });
          throw "422";
        }
        return response;
      })
      .then(response => response.json())
      .then(function (goodsReceivedNotice) {
        dispatch({ goodsReceivedNotice, type: 'SET_GOODS_RECEIVED_NOTICE' });
        dispatch(loadGoodsReceivedNotices(goodsReceivedNotice.delivery_date));
      });
  };
}

export function saveGoodsReceivedNotice({ id, currentDate, deliveryDate, noticeEvents = [], packingLists, pallets, packingCondition, unitsReceived }) {
  const goods_received_notice_events_attributes = noticeEvents.map(event =>
    ({ id: event.id, cartons_received: event.cartonsReceived }));

  const body = { goods_received_notice: { delivery_date: deliveryDate,
                                          goods_received_notice_events_attributes,
                                          packing_condition_attributes: packingCondition,
                                          packing_lists_attributes: packingLists,
                                          pallets,
                                          units_received: unitsReceived } };

  return updateGrn(id, body, currentDate);
}

export function markGoodsReceivedNoticeEventReceivedStatus(grnId, eventId, isReceived, allReceived, currentDate) {
  const goods_received_notice_events_attributes = [{ id: eventId, received: isReceived }];
  let goodsReceivedNotice = { goods_received_notice: { id: grnId, goods_received_notice_events_attributes } };
  return updateGrn(grnId, goodsReceivedNotice, currentDate);
}

export function markGoodsReceivedNoticeEventsDeliveredStatus(grnId, events, delivered, currentDate) {
  const goods_received_notice_events_attributes = events.map(event => ({ id: event.id, delivered }));
  let goodsReceivedNotice = { goods_received_notice: { id: grnId, goods_received_notice_events_attributes } };

  return updateGrn(grnId, goodsReceivedNotice, currentDate);
}

export function markGoodsReceivedNoticeEventsReceivedStatus(grnId, events, received, currentDate) {
  const goods_received_notice_events_attributes = events.map(event => ({ id: event.id, received }));
  let goodsReceivedNotice = { goods_received_notice: { id: grnId, goods_received_notice_events_attributes } };

  return updateGrn(grnId, goodsReceivedNotice, currentDate);
}

export function addPurchaseOrderToGoodsReceivedNotice({ id, userId, purchaseOrderId, units, cartons, pallets, currentDate }) {
  const goods_received_notice_events_attributes = [{ units,
                                                     cartons,
                                                     pallets,
                                                     purchase_order_id: purchaseOrderId,
                                                     user_id: userId }];
  const goodsReceivedNotice = { goods_received_notice: { id, goods_received_notice_events_attributes } };
  return updateGrn(id, goodsReceivedNotice, currentDate);
}

export function clearGoodsReceivedNotice() {
  return { type: 'CLEAR_GOODS_RECEIVED_NOTICE' };
}

export function removePurchaseOrderFromGoodsReceivedNotice({ id, goodsReceivedNoticeEventId, currentDate }) {
  const goods_received_notice_events_attributes = [{ id: goodsReceivedNoticeEventId, _destroy: 1 }];
  const goodsReceivedNotice = { goods_received_notice: { id, goods_received_notice_events_attributes } };
  return updateGrn(id, goodsReceivedNotice, currentDate);
}

export function combineGoodsReceivedNotices({ from, to }) {
  return dispatch => {
    fetch(`/api/goods_received_notices/${to}/combine.json`, { credentials: 'same-origin',
                                                              method: 'POST',
                                                              headers: { 'Content-Type': 'application/json' },
                                                              body: JSON.stringify({ from }) })
      .then(response => response.json())
      .then(function (goodsReceivedNotice) {
        dispatch({ goodsReceivedNotice, type: 'SET_GOODS_RECEIVED_NOTICE' });
        dispatch(loadGoodsReceivedNotices(goodsReceivedNotice.delivery_date));
      });
  };
}

export function deleteGoodsReceivedNotice({ id, currentDate }) {
  return dispatch => {
    fetch(`/api/goods_received_notices/${id}.json`, { credentials: 'same-origin',
                                                      method: 'DELETE',
                                                      headers: { 'Content-Type': 'application/json' } })
      .then(response => response.json())
      .then(function () {
        dispatch(clearGoodsReceivedNotice());
        dispatch(loadGoodsReceivedNotices(currentDate));
      });
  };
}

export function deleteGoodsReceivedNoticePackingList({ id, packingListUrl }) {
  return dispatch => {
    const url = `/api/goods_received_notices/${id}/delete_packing_list.json`;
    const body = { packing_list_attributes: { list_url: packingListUrl } };

    fetch(url, { credentials: 'same-origin',
                 method: 'DELETE',
                 headers: { 'Content-Type': 'application/json' },
                 body: JSON.stringify(body) })
      .then(response => response.json())
      .then(function (goodsReceivedNotice) {
        dispatch({ text: `${packingListUrl} has now been removed successfully.`, type: 'SUCCESS_NOTIFICATION' });
        dispatch({ goodsReceivedNotice, type: 'SET_GOODS_RECEIVED_NOTICE' });
      })
      .catch(function () {
        dispatch({ text: `Unable to delete ${packingListUrl}`, type: 'ERROR_NOTIFICATION' });
      });
  };
}
