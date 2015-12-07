import 'whatwg-fetch';
import Qs from 'qs';
import { isEmptyObject } from '../utilities/inspection';

function loadFilters(type, query, action) {
  let url =`/api/filters/${type}.json`;

  if (!isEmptyObject(query)) {
    url += `?${Qs.stringify(query)}`;
  }

  return dispatch => {
    fetch(url, { credentials: 'same-origin' })
      .then(response => response.json())
      .then(filters => dispatch(action(filters)));
  };
}

export function loadVendors(query) {
  return loadFilters('vendors', query, brands => ({ brands, type: 'SET_FILTER_BRANDS' }));
}

export function loadCategories() {
  return loadFilters('categories', {}, categories => ({ categories, type: 'SET_FILTER_CATEGORIES' }));
}

export function loadGenders() {
  return loadFilters('genders', {}, genders => ({ genders, type: 'SET_FILTER_GENDERS' }));
}

export function loadOrderTypes() {
  return loadFilters('order_types', {}, orderTypes => ({ orderTypes, type: 'SET_FILTER_ORDER_TYPES' }));
}

export function loadSeasons() {
  return loadFilters('seasons', {}, seasons => ({ seasons, type: 'SET_FILTER_SEASONS' }));
}

export function loadSuppliers(query) {
  return loadFilters('suppliers', query, suppliers => ({ suppliers, type: 'SET_FILTER_SUPPLIERS' }));
}

export function loadBuyers() {
  return loadFilters('buyers', {}, buyers => ({ buyers, type: 'SET_FILTER_BUYERS' }));
}

export function loadBuyerAssistants() {
  return loadFilters('buyer_assistants', {}, buyerAssistants => ({ buyerAssistants, type: 'SET_FILTER_BUYER_ASSISTANTS' }));
}

export function loadSupplierTermsList() {
  return loadFilters('supplier_terms_list', {}, supplierTermsList => ({ supplierTermsList, type: 'SET_SUPPLIER_TERMS_LIST' }));
}
