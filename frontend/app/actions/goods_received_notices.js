import Qs from 'qs';
import 'whatwg-fetch';
import moment from 'moment';

export function loadGoodsReceivedNotice(id) {
  return dispatch => {
    fetch(`/api/goods_received_notices/${id}.json`, { credentials: 'same-origin' })
      .then(response => response.json())
      .then(goodsReceivedNotice => {
        dispatch({ goodsReceivedNotice, type: 'SET_GOODS_RECEIVED_NOTICE' });
      })
      .catch(() => {
        dispatch({ text: `Unable to find GRN ${id}`, type: 'ERROR_NOTIFICATION' });
      });
  };
}

export function loadGoodsReceivedNotices(middleWeekStart) {
  const startDate = moment(middleWeekStart, 'DD/MM/YYYY').subtract(2, 'weeks').format('YYYY-MM-DD');
  const endDate = moment(middleWeekStart, 'DD/MM/YYYY').add({ weeks: 2 }).format('YYYY-MM-DD');

  return dispatch => {
    const queryString = Qs.stringify({ start_date: startDate, end_date: endDate });

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
      .then(goodsReceivedNotice => {
        dispatch({ goodsReceivedNotice, type: 'SET_GOODS_RECEIVED_NOTICE' });
        dispatch(loadGoodsReceivedNotices(currentDate));
      });
  };
}

function updateGrn(id, body, currentDate) {
  return dispatch => {
    fetch(`/api/goods_received_notices/${id}.json`, { credentials: 'same-origin',
                                                      method: 'PATCH',
                                                      headers: { 'Content-Type': 'application/json' },
                                                      body: JSON.stringify(body) })
      .then(response => response.json())
      .then(goodsReceivedNotice => {
        dispatch({ goodsReceivedNotice, type: 'SET_GOODS_RECEIVED_NOTICE' });
        dispatch(loadGoodsReceivedNotices(currentDate));
      });
  };
}

export function saveGoodsReceivedNotice({ id, deliveryDate, currentDate, packingLists }) {
  return updateGrn(id, { goods_received_notice: { delivery_date: deliveryDate, packing_lists_attributes: packingLists } }, currentDate);
}

export function addPurchaseOrderToGoodsReceivedNotice({ id, purchaseOrderId, units, cartons, pallets, currentDate }) {
  const goods_received_notice_events_attributes = [{ units, cartons, pallets, purchase_order_id: purchaseOrderId }];
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
  const body = {
    packing_list_attributes: { list_url: packingListUrl },
  };
  return dispatch => {
    fetch(`/api/goods_received_notices/${id}/delete_packing_list.json`, { credentials: 'same-origin',
                                                      method: 'DELETE',
                                                      headers: { 'Content-Type': 'application/json' },
                                                      body: JSON.stringify(body),
                                                    })
      .then(response => response.json())
      .then((goodsReceivedNotice) => {
        dispatch({ text: `${packingListUrl} has now been removed successfully.`, type: 'SUCCESS_NOTIFICATION' });
        dispatch({ goodsReceivedNotice, type: 'SET_GOODS_RECEIVED_NOTICE' });
      })
      .catch(() => {
        dispatch({ text: `Unable to delete ${packingListUrl}`, type: 'ERROR_NOTIFICATION' });
      });
  };
}
