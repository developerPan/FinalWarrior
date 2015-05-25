local Log = {}
function Log:sysInfo(info)
    print("@@ [INFO SYS] "..info)
end

function Log:testInfo(info)
    print("## [INFO TEST]"..info)
end
return Log