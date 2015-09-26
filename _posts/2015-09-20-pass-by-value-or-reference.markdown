---
layout:   post
title:    "Pass By Value or Reference?"
date:     2015-09-20 17:50:13
comments: true
---
A question as old as time, "Does this language use pass-by-value or pass-by-reference?".

As it turns out, few programmers actually care about the definition of those words when they ask that question. What they really mean is, what will happen in the following situations?

{% highlight php %}
<?php
function modify_in_place($prices) {
	$prices[0] = 100;
}

function modify_location($prices) {
	$prices = [40, 50, 60];
}

$prices = [1, 2, 3];
modify_in_place($prices);
if ($prices[0] == 100) {
    echo "Pass-by-reference!\n";
} else {
    echo "Pass-by-value!\n"; // Yep
}

$prices = [1, 2, 3];
modify_location($prices);
if ($prices[0] == 40) {
    echo "Pass-by-reference!\n";
} else {
    echo "Pass-by-value!\n"; // Yep
}
?>
{% endhighlight %}

In the first example, we modify the array parameter in place. Our changes aren't visible outside of our function, so we have plain old pass-by-value.

So what's with the second example? Its used to show the different between pass-by-reference and a more subtle idea, pass *object references* by value. More on that in a bit.

For PHP which allows an explicit pass-by-reference, we'll add two more tests.

{% highlight php %}
<?php
function modify_in_place_by_ref(&$prices) {
	$prices[0] = 100;
}

function modify_location_by_ref(&$prices) {
	$prices = [40, 50, 60];
}

$prices = [1, 2, 3];
modify_in_place_by_ref($prices);
if ($prices[0] == 100) {
    echo "Pass-by-reference!\n"; // Yep
} else {
    echo "Pass-by-value!\n";
}

$prices = [1, 2, 3];
modify_location_by_ref($prices);
if ($prices[0] == 40) {
    echo "Pass-by-reference!\n"; // Yep
} else {
    echo "Pass-by-value!\n";
}
?>
{% endhighlight %}

So if we really want pass-by-reference, we can get it. Cool, so we have pass-by-value and explicit pass-by-reference. What happens if we try the same test in Python?

{% highlight python %}
def modify_in_place(prices):
    prices[0] = 100;

def modify_location(prices):
    prices = [40, 50, 60];
    
prices = [1, 2, 3];
modify_in_place(prices);
if prices[0] == 100:
    print "Pass-by-reference!\n"; # Yep
else:
    print "Pass-by-value!\n";

prices = [1, 2, 3];
modify_location(prices);
if prices[0] == 40:
    print "Pass-by-reference!\n";
else:
    print "Pass-by-value!\n"; # Yep
{% endhighlight %}

Uhhhhhh hrrmmmmm ok. So we can modify our array in place, which looks like pass-by-reference. But we can't reassign our array to something else and have it stick. What does that look like ...

{% highlight c %}
void modify_in_place(int* prices) {
    prices[0] = 100;
}

void modify_location(int* prices) {
    int p2[3] = {40, 50, 60};
    prices = p2;
}

int main()
{
    int prices[3] = {1, 2, 3};
    modify_in_place(prices);
    if (prices[0] == 100) {
        printf("Pass by reference!\n"); // Yep
    } else {
        printf("Pass by value!\n");
    }
    
    int prices2[3] = {1, 2, 3};
    modify_location(prices2);
    if (prices2[0] == 40) {
        printf("Pass by reference!\n");
    } else {
        printf("Pass by value!\n"); // Yep
    }
    return 0;
}
{% endhighlight %}

First of all, why are we passing in an array but receiving an `int*` in our function? Arrays will decay to pointers when passed in C (and C++). This behaviour makes more sense looking at it in C; changing what our pointer points to in `modify_location` shouldn't change anything outside our function, because that's just our local copy of a pointer to the array.

C only provides pass-by-value. So what actually happened in the first case? Well just like Python, Java, Javascript and C#, C is passing the reference to the array by value. In C, this means we are passing a pointer, which our function receives its own local copy of. We can dereference that pointer and change the underlying structure and have it seen from outside our function as in `modify_in_place`, but we can't change what the original pointer points to - for that we would need an `int**`.

So a lot of languages are actually providing this pass-by-value only thing, including passing object references by value. C++ provides pass-by-reference with a modified function prototype, similar to how PHP does it: `modify_location_by_ref(int*& prices)`. Notice here we are actually passing the pointer by reference - this gives us the same semantics as PHP, where `modify_in_place` will dutifully modify our array, and `modify_location` will actually change where our original pointer points to. This example is less confusing in C++ if you use something that isn't an array which decays to a pointer.

So why does PHP provide pass-by-value for arrays, and not pass object reference by value? Who knows. But they do. This has actually ended up having severe consequences for PHP. Arrays are passed by value by default - that looks like a whole lot of copying going on. In reality, PHP implements a nice delayed copy, only actually copying the elements when they need to. Unfortunately this relies on reference counting garbage collection: read more in my [Honours thesis](/portfolio/php-garbage-collection/).

