const middleware = {}

middleware['authCheck'] = require('../middleware/authCheck.js')
middleware['authCheck'] = middleware['authCheck'].default || middleware['authCheck']

middleware['checkNotifications'] = require('../middleware/checkNotifications.js')
middleware['checkNotifications'] = middleware['checkNotifications'].default || middleware['checkNotifications']

middleware['checkUserExistence'] = require('../middleware/checkUserExistence.js')
middleware['checkUserExistence'] = middleware['checkUserExistence'].default || middleware['checkUserExistence']

middleware['isLoggedIn'] = require('../middleware/isLoggedIn.js')
middleware['isLoggedIn'] = middleware['isLoggedIn'].default || middleware['isLoggedIn']

export default middleware
