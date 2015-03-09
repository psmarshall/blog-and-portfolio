---
layout:   post
title:    "Creating This Blog"
date:     2015-03-08 14:29:25
comments: true
---
I was looking for a way to provide both a portfolio and blog in one site without creating too much from scratch and came across [Jekyll][jekyll]. Jekyll generates a static site from simple file formats like Markdown, meaning you can take advantage of a simple server setup without any databases or other added complexity.

The basic Jekyll site on the default template provides a good basis for blogging, but doesn't give you the ability to generate static pages for projects to show off what you've been working on. I used the [Flatterline Jekyll Plugins][jekyll-plugin], specifically portfolio.rb to give me a portfolio index page and a separate page for each project. This gave me a blog and a portfolio out of the box, and worked great. The only issue was that every project would show up in the top navigation bar.

![Navigation Bar Screenshot](/images/navbar.png)

This looked untidy, and would also cause issues as more and more projects were added.

I had a look inside portfolio.rb:

{% highlight ruby %}
def write_project_index(site, path, name)
  project = ProjectIndex.new(site, site.source, "/portfolio/#{name}", path)

  if project.data['published']
    project.render(site.layouts, site.site_payload)
    project.write(site.dest)

    # site.pages << project
    site.static_files << project
  end
end
{% endhighlight %}

I commented out the line where each project was being added to the site.pages. Each project page was still generated and linked to from the [portfolio page][portfolio], they were just no longer listed in the nav bar - exactly what I wanted.

My original plan was to host this site on [GitHub Pages][pages], which is powered by Jekyll. However they don't allow Jekyll plugins in general, except for a few which they have whitelisted, and given the need for the portfolio section, I decided to host it on a paid server instead. That said, I'm happy with how it turned out, so keep an eye out as I fiddle with the final look over the next few weeks.


[jekyll]:        http://jekyllrb.com
[jekyll-plugin]: https://github.com/flatterline/jekyll-plugins
[portfolio]:     /portfolio/index.html
[pages]:         https://pages.github.com/
