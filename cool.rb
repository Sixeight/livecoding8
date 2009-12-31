command = `which pandoc`.empty? ? 'rdiscount' : 'pandoc'
@body = `#{command} README.md`

test_mode = false
if ARGV.length == 1 || ARGV[0] == '-t'
  test_mode = true
end

if __FILE__ == $0
  unless test_mode
    # assume current branch is master
    if false # TODO: If gh-pages isn't exist
      system "git branch gh-pages origin/gh-pages"
    end
    system "git push"
    system "git checkout gh-pages"
    system "git merge master"
  end
  system "erb -r #{__FILE__} -T - -P index.erb > index.html"
  system "ruby a.rb > feed.rss"
  unless test_mode
    system "git add index.html feed.rss"
    system "git commit -m 'Automatically updated index.html and feed.rss'"
    system "git push origin gh-pages"
    system "git checkout master"
  end
end
