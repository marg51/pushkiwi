module.exports = function(config) {
  config.set({
    files : [
      'bower_components/angular/angular.js',
      'bower_components/angular-mocks/angular-mocks.js',

      "bower_components/angular-animate/angular-animate.min.js",
      "bower_components/angular-sanitize/angular-sanitize.min.js",
      "bower_components/angular-ui-router/release/angular-ui-router.min.js",
      "bower_components/angular-webkit-require/dist/app.js",
      "bower_components/flex/dist/ng-flexbox.js",
      "bower_components/angular-loading-bar/build/loading-bar.min.js",
      "bower_components/lodash/dist/lodash.min.js",

      
      'src/coffee/*.coffee',
      'tests/unit/*.coffee'
    ],
    preprocessors: {
      '**/*.coffee': ['coffee']
    },
    basePath: '../',
    frameworks: ['jasmine'],
    reporters: ['progress'],
    browsers: ['NodeWebkit'],
    autoWatch: true,
    singleRun: false,
    colors: true
  });
};
