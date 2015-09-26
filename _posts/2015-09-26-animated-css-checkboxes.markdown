---
layout:   post
title:    "Animated CSS Checkboxes"
date:     2015-09-26 17:43:54
comments: true
custom_css: checkboxes
---

For a project I'm working on we needed to create a nice interaction to let users know that they've done something good. I started looking in to CSS animations and custom checkboxes and found out it is pretty complicated. Getting things to work across different browsers, even just the most recent ones is a pain as well. Here's a look at what we ended up going with (click them!).

<div class="ticks">
    <div class="tick-sub">
        <input type="checkbox" id="submit-tick" name="submit-tick" />
        <label for="submit-tick"></label>
    </div>
    <div class="tick-cross">
        <input type="checkbox" id="submit-cross" name="submit-cross" />
        <label for="submit-cross"></label>
    </div>
</div>

The HTML is fairly straight forward:

{% highlight html %}
<div class="ticks">
    <div class="tick-sub">
        <input type="checkbox" id="submit-tick" name="submit-tick" />
        <label for="submit-tick"></label>
    </div>
    <div class="tick-cross">
        <input type="checkbox" id="submit-cross" name="submit-cross" />
        <label for="submit-cross"></label>
    </div>
</div>
{% endhighlight %}

There are a few crucial pieces here, though. First we have a div called "ticks" to wrap the whole thing. An inner div for each checkbox is going to act as our background and wrap up our checkbox and label. The HTML input element has a type "checkbox" and that provides us with the basic checking and unchecking functionality so we don't have to rewrite those parts. It also lets you use these checkboxes in a form directly and all the other perks that come with HTML input elements.

CSS will also be able to recognise when they are checked or not using the `:checked` [pseudo-class][w3pseudoc]. The labels actually do most of the work for us, and we add the tick/cross as a `::before` [pseudo-element][w3pseudoe] and the animation as an `::after` pseudo-element.

First of all, we need to hide the ugly default checkboxes and center up our pretty ones:
{% highlight css %}
.ticks input {
  display: none;
}
.ticks {
  text-align: center;
}
{% endhighlight %}

The rest of the CSS is a bit more convoluted (note that this is actually SCSS):

{% highlight scss %}
.tick-sub, .tick-cross {
    /* Grey background on the div itself */
    display: inline-block;
    width: 50px;
    height: 50px;
    border-radius: 25px;
    margin: 8px;
    background: #cbd1d8;
    label {
        /* The label defines the clickable region so make sure
           the dimensions match up. Also set up the pointer so
           users know its clickable. */
        display: block;
        width: 50px;
        height: 50px;
        border-radius: 25px;
        padding: 0px;
        position: relative;
        cursor: pointer;
        &::before {
            /* The tick. */
            display: block;
            content:'\2714';
            text-align: center;
            line-height: 50px;
            color: #fff;
            font-size: 2rem;
        }
        &:hover {
            /* Respond to hovering cursor to indicate we want
               to be clicked. */
            background: #9faab7;
        }
    }
    input:checked + label::after {
        /* Fire out animation in the ::after pseudo-element */
        -webkit-animation: click-wave 0.85s;
        -moz-animation: click-wave 0.85s;
        animation: click-wave 0.85s;
        background: #2fb207;
        content:'';
        display: inline-block;
        position: absolute;
        left: 0px;
        top: 0px;
        z-index: 100;
    }
    input:checked + label {
        /* Special background colour once we've been ticked */
        background: #2fb207;
    }
    &.tick-cross {
        /* Customise above settings for the cross */
        input:checked + label::after {
            background: darkorange;
        }
        input:checked + label {
            background: darkorange;
        }
        label {
            &::before {
                content:'\2716';
            }
        }
    }
}
{% endhighlight %}

The final piece we are missing is the definition of `click-wave`. I just provide one here, but you need the same thing for @-webkit-keyframes, @-moz-keyframes and @-o-keyframes.

We just have two simple keyframes which describe the start and end point of the animation. We start with a circle the size of the checkbox and expand out to a much large circle as we slowly fade out:

{% highlight scss %}
@keyframes click-wave {
    0% {
        width: 50px;
        height: 50px;
        border-radius: 25px;
        opacity: 0.5;
    }
    100% {
        width: 300px;
        height: 300px;
        border-radius: 150px;
        margin-left: -125px;
        margin-top: -125px;
        opacity: 0.0;
    }
}
{% endhighlight %}


[w3pseudoc]:        http://www.w3schools.com/css/css_pseudo_classes.asp
[w3pseudoe]:        http://www.w3schools.com/css/css_pseudo_elements.asp
