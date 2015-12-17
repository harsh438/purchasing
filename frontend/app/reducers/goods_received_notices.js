import { assign, mapValues, sum, reduce, values } from 'lodash';
import moment from 'moment';

const initialState = { noticeWeeks: {} };

function placeReceivedNoticeIntoDay(byDate, notice) {
  if (!byDate[notice.deliveryDate]) {
    byDate[notice.deliveryDate] = { deliveryDate: notice.deliveryDate,
                                    notices: [notice] };
  } else {
    byDate[notice.deliveryDate].notices.push(notice);
  }
}

function reduceGoodsReceivedNoticesByWeek(byWeek, notice) {
  const date = moment(notice.deliveryDate, 'DD/MM/YYYY');
  const start = date.startOf('isoweek').format('DD/MM/YYYY');

  if (!byWeek[start]) {
    const weekNum = date.isoWeek();
    const end = date.startOf('isoweek').add(5, 'days').format('DD/MM/YYYY');

    byWeek[start] = { weekNum,
                      start,
                      end,
                      noticesByDate: {} };
  }

  placeReceivedNoticeIntoDay(byWeek[start].noticesByDate, notice);

  return byWeek;
}

function buildGoodsReceivedNoticesByWeek(goodsReceivedNotices) {
  return reduce(goodsReceivedNotices, reduceGoodsReceivedNoticesByWeek, {});
}

function addCounts(byWeek) {
  return mapValues(byWeek, function (week) {
    const noticesByDate = mapValues(week.noticesByDate, function (date) {
      const units = sum(date.notices, 'units');
      const cartons = sum(date.notices, 'cartons');
      const pallets = sum(date.notices, 'pallets');
      return assign({}, date, { units, cartons, pallets });
    });

    const units = sum(noticesByDate, 'units');
    const cartons = sum(noticesByDate, 'cartons');
    const pallets = sum(noticesByDate, 'pallets');
    return assign({}, week, { noticesByDate, units, cartons, pallets });
  });
}

export default function reduceGoodsReceivedNotices(state = initialState, action) {
  switch (action.type) {
  case 'SET_GOODS_RECEIVED_NOTICES':
    const noticesByWeek = addCounts(buildGoodsReceivedNoticesByWeek(action.goodsReceivedNotices));
    return assign({}, state, { noticeWeeks: values(noticesByWeek) });
  default:
    return state;
  }
}
