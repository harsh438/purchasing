export function loadUsers() {
  return dispatch => {
    fetch('/api/users.json', { credentials: 'same-origin' })
      .then(response => response.json())
      .then(users => dispatch({ users, type: 'SET_USERS' }));
  };
}
