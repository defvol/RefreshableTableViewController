RefreshableTableViewController
==============================
_EGOTableViewPullRefresh with infinite-scrolling superpowers for RubyMotion._

[![endorse](http://api.coderwall.com/wilhelmbot/endorsecount.png)](http://coderwall.com/wilhelmbot)

**NOTE:** The example app is based on the demo app "Tweets" from the HipByte's RubyMotionSamples.

Usage
=
Controller setup
-
```ruby
# Inherit all the magic
class TweetsController < RefreshableTableViewController
  # ...
  def viewDidLoad
    # Must call super to allow Refreshable load its initial setup
    super
    # ...
  end
end
```
Infinite scrolling
-
```ruby
def viewDidLoad
  # ...
  # Get older tweets when scrolling reaches bottom of table view
  @callbacks[:infinite_scroll] = lambda {
    get_tweets(max_id: @tweets.lastObject.id) if @tweets.lastObject
  }
end
```
Pull to refresh
-
```ruby
# Override pull to refresh handler to download new tweets
def refreshTableHeaderDidTriggerRefresh(view)
  get_tweets(since_id: @tweets.first.id) if @tweets.first
end

def your_downloader_callback
  # ...
  # Stop pull-to-refresh loading animation
  doneReloadingTableViewData
end
```

**References and attributions:**  
* https://github.com/enormego/EGOTableViewPullRefresh  
* https://github.com/rjowens/TableViewPullRefresh  
* https://github.com/HipByte/RubyMotionSamples  

