using ArgParse


function ARGUMENTS()
    settings = ArgParseSettings(
        prog="X9",
        description="""
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n
        **** Customize Parameters in URL(s) ***
        \n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        """
    )
    @add_arg_table settings begin
        "-u", "--url"
        help = "single url"

        "-U", "--urls"
        help = "list of urls in file"

        "-p", "--parameters"
        help = "list of parameters in file"

        "-v", "--values"
        help = "list of values in file"

        "--ignore"
        help = "does not change the default parameters, just appends the given parameters with the given values to the end of the URL"
        action = :store_true

        "--replace-all"
        help = "Replaces all default parameter's values with the given values and appends the given parameters with the given values to the end of the URL"
        action = :store_true

        "--replace-alt"
        help = "just replaces the default parameter values with the given values alternately"
        action = :store_true

        "--suffix-all"
        help = "append the given values to the end of all the default parameters"
        action = :store_true

        "--suffix-alt"
        help = "append the given values to the end of default parameters alternately"
        action = :store_true

        "--all"
        help = "do all --ignore, --replace-all, --replace-alt, --suffix-all, --suffix-alt"
        action = :store_true

        "-c", "--chunk"
        help = "maximum number of parameters in url"
        arg_type = Int
        default = 10000

        "-o", "--output"
        help = "save output in file"
    end
    parsed_args = parse_args(ARGS, settings)
    if parsed_args["all"]
        for arg in ["ignore", "replace-all", "replace-alt", "suffix-all", "suffix-alt"]
            parsed_args[arg] = true
        end
    end
    return parsed_args
end

res = String[]

function parameters(url::String)
    reg = r"[\?,\&,\;][\w\-]+[\=,\&,\;]?([\w,\-,\%,\.]+)?"
    return [i.captures[1] for i in eachmatch(reg, url)]
end

function custom_parmeters(Values::Vector{String}, Keys::Vector{String})
    keys = filter(!isempty, Keys)
    ress = String[]
    for (k, v) in Iterators.product(Keys, Values)
        if !isempty(k)
            push!(ress, "&$k=$v")
        end
    end
    return unique(ress)
end

function CHUNK(url::String, custom_params::Vector{String}, params_count, chunk::Int)
    if chunk < params_count
        @warn "chunk cant be less than default parameters count \ndefault parameters = $params_count\nchunk = $chunk"
        exit(0)
    end
    k = abs(params_count - chunk)
    if k >= 1 && !isempty(custom_params)
        for item in Iterators.partition(custom_params, k)
            push!(res, url * join(item))
        end
    else
        push!(res, url)
    end
end

function ignore(; urls::Vector{String}, Keys::Vector{String}=[""], Values::Vector{String}, chunk::Int)
    for url in urls
        for value in Values
            params = parameters(url)
            params_count = length(params)
            custom = custom_parmeters([value], Keys)
            CHUNK(url, custom, params_count, chunk)
        end
    end
end

function replace_all(; urls::Vector{String}, Keys::Vector{String}=[""], Values::Vector{String}, chunk::Int)
    for url in urls
        for value in Values
            custom = custom_parmeters([value], Keys)
            kv = Dict{String,String}()
            params = parameters(url)
            params_count = length(params)
            for param in params
                get!(kv, param, value)
            end
            for (k, v) in sort([(k, v) for (k, v) in pairs(kv)], by=item -> length(item[1]), rev=true)
                url = replace(url, k => v)
            end
            CHUNK(url, custom, params_count, chunk)
        end
    end
end

function replace_alternative(; urls::Vector{String}, Values::Vector{String})
    for url in urls
        params = parameters(url)
        for (param, value) in Iterators.product(params, Values)
            push!(res, replace(url, param => value))
        end
    end
end

function suffix_all(; urls::Vector{String}, Values::Vector{String})
    for url in urls
        for value in Values
            params = parameters(url)
            for (p, v) in Iterators.product(params, [value])
                url = replace(url, p => join([p, v]))
            end
            push!(res, url)
        end
    end
end

function suffix_alternative(; urls::Vector{String}, Values::Vector{String})
    for url in urls
        params = parameters(url)
        for (param, value) in Iterators.product(params, Values)
            push!(res, replace(url, param => join([param, value])))
        end
    end
end

function Write(filename::String, mode::String, data::String)
    open(filename, mode) do file
        write(file, data)
    end
end

function main()
    arguments = ARGUMENTS()

    if !isnothing(arguments["url"])
        url = [arguments["url"]]
    elseif !isnothing(arguments["urls"])
        url = readlines(arguments["urls"])
    end

    arguments["ignore"] && ignore(
        urls=url,
        Keys=readlines(arguments["parameters"]),
        Values=readlines(arguments["values"]),
        chunk=arguments["chunk"]
    )

    arguments["replace-all"] && replace_all(
        urls=url,
        Keys=readlines(arguments["parameters"]),
        Values=readlines(arguments["values"]),
        chunk=arguments["chunk"]
    )

    arguments["replace-alt"] && replace_alternative(
        urls=url,
        Values=readlines(arguments["values"])
    )

    arguments["suffix-all"] && suffix_all(
        urls=url,
        Values=readlines(arguments["values"])
    )

    arguments["suffix-alt"] && suffix_alternative(
        urls=url,
        Values=readlines(arguments["values"])
    )

    isnothing(arguments["output"]) ? print(join(unique(res), "\n")) : Write(arguments["output"], "w+", join(unique(res), "\n"))
end

main()