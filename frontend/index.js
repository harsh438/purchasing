import ReactDOM from 'react-dom';

import buildFetch from 'fetch-ponyfill';
global.fetch = buildFetch({});

import Root from './app/root';

ReactDOM.render(Root, document.getElementById('app'));
