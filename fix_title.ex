

integer file_count = 0
integer title_replacements = 0
sequence ls = dir("html")

function read_text_file(sequence path)
    integer fn = open(path, "r")
    if fn = -1 then
        return -1
    end if

    sequence content = ""
    object line
    while 1 do
        line = gets(fn)
        if atom(line) then
            exit
        end if
        content = append(content, line)
    end while
    close(fn)
    return join(content,"")
end function


procedure fix_title(sequence s)
    sequence filename = sprintf("html/%s", {s})
    sequence str_to_find = "<title>OpenEuphoria: Euphoria v4.1</title>";
    sequence replace_with = sprintf("<title>%s</title>",{s})
    object data = read_text_file(filename)
    if atom(data) then
        printf(1, "could not open file [%s]\n", {s})
        abort(1)
    end if
    file_count += 1
    if match(str_to_find, data) then
        data = match_replace(str_to_find, data, replace_with, 1)
        title_replacements += 1   
        integer fp = open(filename, "w")
        if fp = -1 then
            printf(1, "could not open file [%s] for writing\n", {filename})
            abort(1)
        end if
        puts(fp, data)
        flush(fp)
        close(fp)
    end if
end procedure

for i=1 to length(ls) do
    sequence f = ls[i]
    printf(1, "Filename is [%s] Is directory is [%d]\n", {f[1], equal(f[2], "d")})
    if match(".html", f[1], length(f[1]) - length(".html")) then
        fix_title(f[1])
    else
        printf(1, "Could not find [.html] in [%s]\n", {f[1]})
    end if
end for

printf(1, "found [%d] .html files.  Replaced title [%d] times\n", {file_count, title_replacements})
