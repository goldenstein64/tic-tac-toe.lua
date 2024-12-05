local bustez = require("bustez")
bustez.register()
_G.expect = bustez.expect --[[@as bustez.expect]]

require("spec.helper.registerMockIO")
require("spec.helper.registerClass")
require("spec.helper.registerContains")
