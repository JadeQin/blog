!#/bin/bash

git add .
git commit -m 'blog'
git push

hugo

cd docs
git add .
git commit -m 'blog'
git push