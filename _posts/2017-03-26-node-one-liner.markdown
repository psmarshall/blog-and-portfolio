---
layout:   post
title:    "Node One Liner"
date:     2017-03-26 10:15:25
comments: true
---
Now that I'm working on V8 as my day job, I'm learning a lot more about Node.js. Node.js lets you run JS on your server or use JS as a scripting language, and it is pretty sweet.

A few weekends ago I went along to a [nodeschool][nodeschool] meetup, where you can learn some basic JS or node skills, and there are mentors to help you along the way. I went as a mentor because we were hosting it at our office. I thought I'd share this little one-liner solution that I came up with for one of the exercises.

I was also working through the [learnyounode][lyn] tutorials, which is about a basic introduction to node.js. The brief for exercise 2 goes like this:

"Write a program that accepts one or more numbers as command-line arguments  
and prints the sum of those numbers to the console (stdout)."

Seems like a pretty standard way to start out with a language. We'll need to detect the number of arguments, add them together one-by-one and then print the number out. Once you know how to access command-line arguments in node, this is pretty straight-forward. Check out the suggested solution:

{% highlight javascript %}
var result = 0
    
for (var i = 2; i < process.argv.length; i++) {
  result += Number(process.argv[i])
}

console.log(result)
{% endhighlight %}

We need to remember to start at argument number 2 (the third argument), because the first argument will be the path to your node binary, and the second argument will be the path to the file that you are running. This solution is maybe a bit too readable though, how about this instead:

{% highlight javascript %}
console.log(process.argv.slice(2).reduce((a,n)=>a- -n))
{% endhighlight %}

This is as short as I could make it, and I'm happy to say it is totally indecipherable. Obviously, we are going to print out result out, so we start with `console.log`. We need to split up the array and only deal with the third element onwards. We use slice for that, and if we give slice just one argument, it assumes we want to start at that element and go until the end of the array, perfect. Reduce takes a function that takes an accumulator and an element of the array, and calls it for each element. Here we add each element `n` to the accumulator, using an arrow function for shorter syntax. Why do we use two minus signs though?

If we just use a single `+`, when we run `node baby.js 1 2 3` we get `123` as the output. The command-line arguments are given as strings, and the `+` operator is happy to keep them as strings. Kind of annoying, but it is better than JS automatically converting only certain types of strings to numbers for us. So we need to convince JS to convert the input arguments to a number for us. We could do this with a `+` operator instead - i.e. `=>a+ +n`. Unfortunately, we get the same result again. Bummer. Why does that happen?

We are calling reduce with only one parameter. We could also call it with `0` as the second parameter, which provides the initial value of the accumulator, but we would use two more characters. Like so: `reduce((a,n)=>a+ +n,0)`. Now, the accumulator starts as a number, so our first calculation has a number on both sides, triggering the 'number plus' instead of the string concatenation operation. But we can still go further!

Instead of using the plus operation, which is overloaded for two strings, we can use the minus operator. The minus operator will convert its arguments to numbers first, automagically! Alas, we are now subtracting instead of adding, so we put in that extra minus, and that's how we get to our final solution. When reduce has no initial accumulator value, it will start the accumulator with the first element of the array. And that's how we write totally, unreasonably short javascript.

[nodeschool]: https://nodeschool.io/
[lyn]:        https://github.com/workshopper/learnyounode