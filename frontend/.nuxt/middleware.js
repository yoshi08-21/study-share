const middleware = {}

middleware['authCheck'] = require('../middleware/authCheck.js')
middleware['authCheck'] = middleware['authCheck'].default || middleware['authCheck']

middleware['isLoggedIn'] = require('../middleware/isLoggedIn.js')
middleware['isLoggedIn'] = middleware['isLoggedIn'].default || middleware['isLoggedIn']

export default middleware
