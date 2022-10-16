-- Globals provided by TiledUp.
--
-- This file can be used by toyboypy (https://toyboxpy.io) to import into a project's luacheck config.
--
-- Just add this to your project's .luacheckrc:
--    require "toyboxes/luacheck" (stds, files)
--
-- and then add 'toyboxes' to your std:
--    std = "lua54+playdate+toyboxes"

return {
    globals = {
        tiledup = {
            fields = {
                Level = {
                    fields = {
                        super = {
                            fields = {
                                className = {},
                                init = {},
                            }
                        },
                        className = {},
                        init = {},
                    }
                },
                Layer = {
                    fields = {
                        super = {
                            fields = {
                                className = {},
                                init = {}
                            }
                        },
                        className = {},
                        init = {}
                    }
                }
            }
        }
    }
}
