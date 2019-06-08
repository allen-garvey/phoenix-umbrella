"use strict";

var path = require('path');
var gulp = require('gulp');
var sass = require('gulp-sass');

var config = require(path.join(__dirname, 'gulp-config.js'));

/*
* Sass/Styles Tasks
*/
gulp.task('sass', ()=>{
    return gulp.src(config.styles.SOURCE_DIR + '**/*.scss')
    .pipe(sass(config.styles.sass_options).on('error', sass.logError))
    .pipe(gulp.dest(config.styles.DEST_DIR));
});


/*
* Watch tasks
*/
gulp.task('watch', ()=>{
    gulp.watch(config.styles.SOURCE_DIR + '**/*.scss', gulp.parallel('sass'));
});

/*
* Main gulp tasks
*/
gulp.task('default', gulp.parallel('sass'));