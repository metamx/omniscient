module.exports = (grunt) ->
  grunt.initConfig {
    coffee: {
      compile: {
        files: {
          'build/stalker.js': [
            'src/init.coffee',
            'src/events.coffee',
            'src/handler.coffee'
          ]
        }
      }
    },

    watch: {
      scripts: {
        files: 'src/*.coffee',
        tasks: ['coffee']
      }
    }
  }

  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-contrib-coffee')

  grunt.registerTask('default', ['coffee', 'watch'])