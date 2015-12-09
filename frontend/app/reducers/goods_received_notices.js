import { assign, reduce } from 'lodash';
import moment from 'moment';

const initialState = { goodsReceivedNoticesByWeek: {} };

function placeReceivedNoticeIntoDay(byDates, notice) {
  if (!byDates[notice.deliveryDate]) {
    byDates[notice.deliveryDate] = { deliveryDate: notice.deliveryDate,
                                     notices: [notice] };
  } else {
    byDates[notice.deliveryDate].notices.push(notice);
  }

  return byDates;
}

function reduceGoodsReceivedNoticesByWeek(byWeek, notice) {
  const week = moment(notice.deliveryDate, 'DD/MM/YYYY').isoWeek();

  if (!byWeek[week]) {
    byWeek[week] = {};
  }

  placeReceivedNoticeIntoDay(byWeek[week], notice);

  return byWeek;
}

function buildGoodsReceivedNoticesByWeek(goodsReceivedNotices) {
  return reduce(goodsReceivedNotices, reduceGoodsReceivedNoticesByWeek, {});
}

function addCounts(byWeek) {
  return byWeek;
}

export default function reduceGoodsReceivedNotices(state = initialState, action) {
  switch (action.type) {
  case 'SET_GOODS_RECEIVED_NOTICES':
    const goodsReceivedNoticesByWeek = addCounts(buildGoodsReceivedNoticesByWeek(action.goodsReceivedNotices));
    return assign({}, state, { goodsReceivedNoticesByWeek });
  default:
    return state;
  }
}
