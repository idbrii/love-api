local pl_string = require('pl.stringx')
local love = require('love_api')



local stub = io.open('love_stub.lua', 'w')

local function writecode(file, indent, text)
    for i=1,indent do
        file:write('\t')
    end
    file:write(text .. '\n')
end

writecode(stub, 0, '-- vim: set fdm=marker:')
writecode(stub, 0, 'local love = {} -- {{{1\n')
for i,mod in ipairs(love.modules) do
    writecode(stub, 0, string.format('local %s = {} -- {{{2', mod.name))
    for _,func in ipairs(mod.functions) do
        for _,variant in ipairs(func.variants) do
            local args = {}
            local arg_doc = {''}

            for _,arg in ipairs(variant.arguments or {}) do
                table.insert(args, arg.name)
                table.insert(arg_doc, string.format('%s\t(%s)\t%s', arg.name, arg.type, arg.description))
            end

            table.insert(arg_doc, '')
            for _,arg in ipairs(variant.returns or {}) do
                table.insert(arg_doc, string.format('returns: %s\t(%s)\t%s', arg.name, arg.type, arg.description))
            end


            writecode(stub, 0, pl_string.join('\n-- ', arg_doc))
            writecode(stub, 0, string.format('function love.%s.%s(%s)', mod.name, func.name, pl_string.join(', ', args)))
            writecode(stub, 0, string.format('end'))
        end
    end
end

