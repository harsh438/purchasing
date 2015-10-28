import React from 'react';
import { Route, IndexRoute, NotFoundRoute } from 'react-router';
import Layout from './views/layouts/application';
import HelloWorld from './views/examples/hello_world';

export default (
  <Route path="/" component={Layout}>
    <IndexRoute component={HelloWorld} />
  </Route>
);
