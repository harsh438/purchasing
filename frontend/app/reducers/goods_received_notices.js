import { assign, map, mapValues, sum, reduce, values } from 'lodash';
import moment from 'moment';
import { camelizeKeys } from '../utilities/inspection';

const initialState = { noticeWeeks: {}, goodsReceivedNotice: null };

function transformNoticeDate(noticeDate) {
  return assign({}, camelizeKeys(noticeDate), { notices: map(noticeDate.notices, camelizeKeys) });
}

function transformNoticeWeek(noticeWeek) {
  let camelizedNoticeWeek = camelizeKeys(noticeWeek);
  camelizedNoticeWeek.noticesByDate = mapValues(camelizedNoticeWeek.noticesByDate, transformNoticeDate);
  return camelizedNoticeWeek;
}

function transformGoodsReceivedNoticeEvents(goodsReceivedNoticeEvent) {
  const grnEvent = camelizeKeys(goodsReceivedNoticeEvent);
  grnEvent.purchaseOrder = camelizeKeys(grnEvent.purchaseOrder);
  return grnEvent;
}

function transformGoodsReceivedNotice(goodsReceivedNotice) {
  const grn = camelizeKeys(goodsReceivedNotice);
  grn.goodsReceivedNoticeEvents = map(grn.goodsReceivedNoticeEvents,
                                      transformGoodsReceivedNoticeEvents);
  return grn;
}

export default function reduceGoodsReceivedNotices(state = initialState, action) {
  switch (action.type) {
  case 'SET_GOODS_RECEIVED_NOTICES':
    const camelizedNotices = map(action.goodsReceivedNotices, transformNoticeWeek);
    return assign({}, state, { noticeWeeks: camelizedNotices });
  case 'SET_GOODS_RECEIVED_NOTICE':
    return assign({}, state, { goodsReceivedNotice: transformGoodsReceivedNotice(action.goodsReceivedNotice) });
  case 'CLEAR_GOODS_RECEIVED_NOTICE':
    return assign({}, state, { goodsReceivedNotice: null });
  default:
    return state;
  }
}
