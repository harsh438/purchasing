import React from 'react';
import { Route, IndexRoute, NotFoundRoute } from 'react-router';
import Layout from './views/layout';
import HelloWorld from './views/hello_world';

export default (
  <Route path="/" component={Layout}>
    <IndexRoute component={HelloWorld} />
  </Route>
);
