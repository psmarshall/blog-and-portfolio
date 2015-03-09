#! /bin/bash
(jekyll build && cd _site && scp -r . sandbox:/var/www/html)
