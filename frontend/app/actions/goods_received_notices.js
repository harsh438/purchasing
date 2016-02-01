import Qs from 'qs';
import 'whatwg-fetch';
import moment from 'moment';

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
