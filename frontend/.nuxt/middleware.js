const middleware = {}

middleware['authCheck'] = require('../middleware/authCheck.js')
middleware['authCheck'] = middleware['authCheck'].default || middleware['authCheck']

middleware['authenticated'] = require('../middleware/authenticated.js')
middleware['authenticated'] = middleware['authenticated'].default || middleware['authenticated']

middleware['currentUser'] = require('../middleware/currentUser.js')
middleware['currentUser'] = middleware['currentUser'].default || middleware['currentUser']

middleware['getUser'] = require('../middleware/getUser.js')
middleware['getUser'] = middleware['getUser'].default || middleware['getUser']

export default middleware
