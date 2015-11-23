var gulp = require('gulp');
var browserify = require('browserify');
var watchify = require('watchify');
var source = require('vinyl-source-stream');
var babelify = require('babelify');
var reactify = require('reactify');
var sass = require('gulp-sass');
var livereload = require('gulp-livereload');

var config = {
  scripts: { src: 'index.js',
             dest: '../api/public/assets/javascripts/' },
  styles:  { src: ['app/assets/stylesheets/app.scss'],
             dest: '../api/public/assets/stylesheets/',
             watch: 'app/assets/stylesheets/**/*.scss' },
  images:  { src: ['app/assets/images/*'],
             dest: '../api/public/assets/images' },
  fonts:   { src: ['app/assets/fonts/*'],
             dest: '../api/public/assets/fonts' }
};

gulp.task('default', Object.keys(config));

gulp.task('watch', ['default'], function () {
  livereload.listen();
  watchBundle(config.scripts.src);
  gulp.watch(config.styles.watch, ['styles']).on('change', livereload.changed);
  gulp.watch(config.images.src, ['images']).on('change', livereload.changed);
  gulp.watch(config.fonts.src, ['fonts']).on('change', livereload.changed);
});

gulp.task('scripts', function () {
  bundler()
    .bundle()
    .pipe(source('app.js'))
    .pipe(gulp.dest(config.scripts.dest));
});

gulp.task('styles', function () {
  gulp.src(config.styles.src)
    .pipe(sass())
    .pipe(gulp.dest(config.styles.dest));
});

gulp.task('images', function () {
  gulp.src(config.images.src)
    .pipe(gulp.dest(config.images.dest));
});

gulp.task('fonts', function () {
  gulp.src(config.fonts.src)
    .pipe(gulp.dest(config.fonts.dest));
});

function bundler () {
  return browserify({ entries: config.scripts.src,
                      extensions: ['.jsx'],
                      transform: [babelify, reactify],
                      fullPaths: false,
                      cache: {},
                      packageCache: {},
                      verbose: true,
                      debug: true });
}

function watchBundle (src) {
  function rebundle () {
    return watcher
      .bundle()
      .pipe(source('app.js'))
      .pipe(gulp.dest(config.scripts.dest))
      .pipe(livereload());
  }

  var watcher = watchify(bundler());
  rebundle();

  return watcher
    .on('error', console.warn.bind(console))
    .on('update', rebundle);
}
