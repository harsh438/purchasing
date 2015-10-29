const initialState = [];

export default function reduceBrands(state = initialState, action) {
  switch (action.type) {
    case 'SET_BRANDS':
      return action.brands;
    default:
      return state;
  }
}
