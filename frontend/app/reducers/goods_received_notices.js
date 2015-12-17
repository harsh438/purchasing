import { assign, map, sum, reduce } from 'lodash';
import moment from 'moment';

const initialState = { noticesByWeek: {} };

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
  const week = date.isoWeek();

  if (!byWeek[week]) {
    byWeek[week] = { weekNum: week,
                     start: date.startOf('isoweek').format('DD/MM/YYYY'),
                     end: date.startOf('isoweek').add(5, 'days').format('DD/MM/YYYY'),
                     noticesByDate: {} };
  }

  placeReceivedNoticeIntoDay(byWeek[week].noticesByDate, notice);

  return byWeek;
}

function buildGoodsReceivedNoticesByWeek(goodsReceivedNotices) {
  return reduce(goodsReceivedNotices, reduceGoodsReceivedNoticesByWeek, {});
}

function addCounts(byWeek) {
  return map(byWeek, function (week) {
    const noticesByDate = map(week.noticesByDate, function (date) {
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
    return assign({}, state, { noticesByWeek });
  default:
    return state;
  }
}
