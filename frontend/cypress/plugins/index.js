const { exec } = require('child_process');
const { defineConfig } = require('cypress')

// module.exports = (on, config) => {
//   on('task', {
//     resetDb() {
//       return new Promise((resolve, reject) => {
//         exec('RAILS_ENV=test bundle exec rake db:reset db:seed', (error, stdout, stderr) => {
//           if (error) {
//             reject(stderr);
//           } else {
//             resolve(stdout);
//           }
//         });
//       });
//     }
//   });
// };


module.exports = defineConfig({
  e2e: {
    setupNodeEvents(on, config) {
      on('task', {
        'resetDb': () => {
          return new Promise((resolve, reject) => {
            exec('RAILS_ENV=test bundle exec rake db:reset db:seed', (error, stdout, stderr) => {
              if (error) {
                reject(stderr);
              } else {
                resolve(stdout);
              }
            });
          });
        },
      })
    },
  },
})
