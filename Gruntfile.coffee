module.exports = (grunt) ->
  grunt.initConfig {
    pkg: grunt.file.readJSON('package.json')

    coffee: {
      compile: {
        files: {
          'build/stalker-<%= pkg.version %>.js': [
            'src/init.coffee',
            'src/events.coffee',
            'src/handler.coffee'
          ],
          'examples/lib/stalker.js': [
            'src/init.coffee',
            'src/events.coffee',
            'src/handler.coffee'
          ]
        }
      }
    },

    uglify: {
      target: {
        files: {
          'build/stalker-<%= pkg.version %>.min.js': ['build/stalker-<%= pkg.version %>.js'],
        }
      }
    }

    watch: {
      scripts: {
        files: 'src/*.coffee',
        tasks: ['coffee', 'uglify']
      }
    }
  }

  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-uglify')

  grunt.registerTask('default', ['coffee', 'uglify', 'watch'])
  return
