gulp = require 'gulp'
browserify = require 'gulp-browserify'
sass = require 'gulp-sass'
prefix = require 'gulp-autoprefixer'
spawn = require('child_process').spawn
server = require('tiny-lr')()
livereload = require('gulp-livereload')
rename = require 'gulp-rename'


gulp.task 'scss', ->
  gulp.src ['./static/src/scss/**/*.scss', '!static/src/scss/foundation/**/*']
  .pipe sass()
  .pipe prefix("> 1%")
  .pipe livereload(server)
  .pipe gulp.dest('./static/dist/css')

gulp.task 'browserify', ->
  gulp.src './static/src/coffee/**/*.coffee'
    .pipe browserify
      insertGlobals: true
      debug: true
      transform: ['coffeeify']
      extensions: ['.coffee']
    .pipe livereload(server)
    .pipe rename('app.js')
    .pipe gulp.dest('./static/dist/js')

gulp.task 'server', ->
  spawn 'nodemon', ['app.coffee'], stdio: 'inherit'

gulp.task 'watch', ->
  server.listen 35729, ->
    gulp.start 'server'
    gulp.watch './static/src/scss/**/*.scss', ['scss']
    gulp.watch './static/src/coffee/**/*.coffee', ['browserify']

# Default task call every tasks created so far.
gulp.task 'default', ['scss', 'browserify']