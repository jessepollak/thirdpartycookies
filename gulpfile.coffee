gulp = require 'gulp'
browserify = require 'gulp-browserify'
sass = require 'gulp-sass'
prefix = require 'gulp-autoprefixer'
spawn = require('child_process').spawn
server = require('tiny-lr')()
livereload = require('gulp-livereload')
rename = require 'gulp-rename'
changed = require 'gulp-changed'
imagemin = require 'gulp-imagemin'

gulp.task 'scss', ->
  gulp.src ['./static/src/scss/**/*.scss', '!static/src/scss/foundation/**/*']
  .pipe sass()
  .pipe prefix("> 1%")
  .pipe livereload(server)
  .pipe gulp.dest('./static/dist/css')

gulp.task 'browserify', ->
  gulp.src './static/src/coffee/**/*.coffee', { read: false }
    .pipe browserify
      insertGlobals: true
      debug: true
      transform: ['coffeeify']
      extensions: ['.coffee']
    .on 'error', console.log
    .pipe livereload(server)
    .pipe rename('app.js')
    .pipe gulp.dest('./static/dist/js')

gulp.task 'images', ->
  output = './static/dist/img'
  gulp.src './static/src/img/**/*'
    .pipe changed(output)
    .pipe gulp.dest(output)
    .pipe imagemin()
    .pipe gulp.dest(output)

gulp.task 'server', ->
  spawn 'nodemon', ['app.coffee', '--watch', './app.coffee'], stdio: 'inherit'

gulp.task 'watch', ->
  server.listen 35729, ->
    gulp.start 'server'
    gulp.watch './static/src/scss/**/*.scss', ['scss']
    gulp.watch './static/src/coffee/**/*.coffee', ['browserify']
    gulp.watch './static/src/img/**/*', ['images']

# Default task call every tasks created so far.
gulp.task 'build', ['scss', 'browserify', 'images']
gulp.task 'heroku:production', ['build']
gulp.task 'default', ['build']
