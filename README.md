
# Intro
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# help Customize Parameters in URL(s) - X9
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Install
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# install julia: https://julialang.org/downloads/    or    snap install julia --classic
# then run this commands in terminal:

* 1. julia -e 'using Pkg; Pkg.add("JSON"); Pkg.add("ArgParse"); Pkg.add("OrderedCollections")'
* 2. git clone https://github.com/mrmeeseeks01/X9.git
* 3. cd X9/
* 4. julia x9.jl -h


# or you can use docker:

* 1. git clone https://github.com/mrmeeseeks01/X9.git
* 2. cd X9/
* 3. docker build -t x9 .
* 4. docker run x9
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Switches
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# optional arguments:

*  -h, --help            show this help message and exit
*  -u, --url             single url
*  -U, --urls            list of urls in file
*  -p, --parameters      list of parameters in file
*  -v, --values          list of values in file
*  -c, --chunk           maximum number of parameters in url (type: Int64, default: 10000)
*  --ignore              does not change the default parameters, just appends the given parameters with the given values to the end of the URL
*  --rep-all             Replaces all default parameter's values with the given values and appends the given parameters with the given values to the end of the URL
*  --rep-alt             just replaces the default parameter values with the given values alternately
*  --suf-all             append the given values to the end of all the default parameters
*  --suf-alt             append the given values to the end of default parameters alternately
*  -A                    do all --ignore, --rep-all, --rep-alt, --suf-all , --suf-alt
*  -o, --output          save output in file
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Examples
```
  url = https://example.com/path1/?param1=value1&param2=value2

  parmas.txt ->   user id login card

  values.txt ->   HELLO BYE
```

<br>

* for custom threads, should pass -t [int] to julia
~~~
> julia -t 2 x9.jl [switches]
~~~

<br>

* using --ignore option
~~~
> julia x9.jl -u "https://example.com/path1/?param1=value1&param2=value2" -p p.txt -v v.txt --ignore

output:
https://example.com/path1/?param1=value1&param2=value2&user=HELLO&id=HELLO&login=HELLO&card=HELLO
https://example.com/path1/?param1=value1&param2=value2&user=BYE&id=BYE&login=BYE&card=BYE
~~~

<br>

* using --ignore option with chunk
~~~
> julia x9.jl -u "https://example.com/path1/?param1=value1&param2=value2" -p p.txt -v v.txt --ignore -c 3 

output:
https://example.com/path1/?param1=value1&param2=value2&user=HELLO
https://example.com/path1/?param1=value1&param2=value2&id=HELLO
https://example.com/path1/?param1=value1&param2=value2&login=HELLO
https://example.com/path1/?param1=value1&param2=value2&card=HELLO
https://example.com/path1/?param1=value1&param2=value2&user=BYE
https://example.com/path1/?param1=value1&param2=value2&id=BYE
https://example.com/path1/?param1=value1&param2=value2&login=BYE
https://example.com/path1/?param1=value1&param2=value2&card=BYE
~~~

<br>

* using --rep-all option
~~~
> julia x9.jl -u "https://example.com/path1/?param1=value1&param2=value2" -p p.txt -v v.txt --rep-all

output:
https://example.com/path1/?param1=HELLO&param2=HELLO&user=HELLO&id=HELLO&login=HELLO&card=HELLO
https://example.com/path1/?param1=BYE&param2=BYE&user=BYE&id=BYE&login=BYE&card=BYE
~~~

<br>

* using --rep-all option with chunk
~~~
> julia x9.jl -u "https://example.com/path1/?param1=value1&param2=value2" -p p.txt -v v.txt --rep-all -c 4

output:
https://example.com/path1/?param1=HELLO&param2=HELLO&user=HELLO&id=HELLO
https://example.com/path1/?param1=HELLO&param2=HELLO&login=HELLO&card=HELLO
https://example.com/path1/?param1=BYE&param2=BYE&user=BYE&id=BYE
https://example.com/path1/?param1=BYE&param2=BYE&login=BYE&card=BYE
~~~

<br>

* using --rep-alt option
~~~
> julia x9.jl -u "https://example.com/path1/?param1=value1&param2=value2" -v v.txt --rep-alt

output:
https://example.com/path1/?param1=HELLO&param2=value2
https://example.com/path1/?param1=value1&param2=HELLO
https://example.com/path1/?param1=BYE&param2=value2
https://example.com/path1/?param1=value1&param2=BYE
~~~


<br>

* using --suf-all  option
~~~
> julia x9.jl -u "https://example.com/path1/?param1=value1&param2=value2" -v v.txt --suf-all 

output:
https://example.com/path1/?param1=value1HELLO&param2=value2HELLO
https://example.com/path1/?param1=value1BYE&param2=value2BYE
~~~

<br>

* using --suf-alt option
~~~
> julia x9.jl -u "https://example.com/path1/?param1=value1&param2=value2" -v v.txt --suf-alt

output:
https://example.com/path1/?param1=value1HELLO&param2=value2
https://example.com/path1/?param1=value1&param2=value2HELLO
https://example.com/path1/?param1=value1BYE&param2=value2
https://example.com/path1/?param1=value1&param2=value2BYE
~~~

<br>

* using -A option
~~~
> julia x9.jl -u "https://example.com/path1/?param1=value1&param2=value2" -p p.txt -v v.txt -A

output:
https://example.com/path1/?param1=value1&param2=value2&user=HELLO&id=HELLO&login=HELLO&card=HELLO
https://example.com/path1/?param1=value1&param2=value2&user=BYE&id=BYE&login=BYE&card=BYE
https://example.com/path1/?param1=HELLO&param2=HELLO&user=HELLO&id=HELLO&login=HELLO&card=HELLO
https://example.com/path1/?param1=BYE&param2=BYE&user=BYE&id=BYE&login=BYE&card=BYE
https://example.com/path1/?param1=HELLO&param2=value2
https://example.com/path1/?param1=value1&param2=HELLO
https://example.com/path1/?param1=BYE&param2=value2
https://example.com/path1/?param1=value1&param2=BYE
https://example.com/path1/?param1=value1HELLO&param2=value2HELLO
https://example.com/path1/?param1=value1BYE&param2=value2BYE
https://example.com/path1/?param1=value1HELLO&param2=value2
https://example.com/path1/?param1=value1&param2=value2HELLO
https://example.com/path1/?param1=value1BYE&param2=value2
https://example.com/path1/?param1=value1&param2=value2BYE
~~~

<br>

* using -A option with chunk
~~~
> julia x9.jl -u "https://example.com/path1/?param1=value1&param2=value2" -p p.txt -v v.txt -A -c 4

output:
https://example.com/path1/?param1=value1&param2=value2&user=HELLO&id=HELLO
https://example.com/path1/?param1=value1&param2=value2&login=HELLO&card=HELLO
https://example.com/path1/?param1=value1&param2=value2&user=BYE&id=BYE
https://example.com/path1/?param1=value1&param2=value2&login=BYE&card=BYE
https://example.com/path1/?param1=HELLO&param2=HELLO&user=HELLO&id=HELLO
https://example.com/path1/?param1=HELLO&param2=HELLO&login=HELLO&card=HELLO
https://example.com/path1/?param1=BYE&param2=BYE&user=BYE&id=BYE
https://example.com/path1/?param1=BYE&param2=BYE&login=BYE&card=BYE
https://example.com/path1/?param1=HELLO&param2=value2
https://example.com/path1/?param1=value1&param2=HELLO
https://example.com/path1/?param1=BYE&param2=value2
https://example.com/path1/?param1=value1&param2=BYE
https://example.com/path1/?param1=value1HELLO&param2=value2HELLO
https://example.com/path1/?param1=value1BYE&param2=value2BYE
https://example.com/path1/?param1=value1HELLO&param2=value2
https://example.com/path1/?param1=value1&param2=value2HELLO
https://example.com/path1/?param1=value1BYE&param2=value2
https://example.com/path1/?param1=value1&param2=value2BYE
~~~