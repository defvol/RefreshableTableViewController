class TweetsController < RefreshableTableViewController
  def viewDidLoad
    # Must call super to initialize RefreshableTable
    super

    @tweets = []

    view.dataSource = view.delegate = self

    get_tweets

    @callbacks[:infinite_scroll] = lambda {
      get_tweets(max_id: @tweets.lastObject.id) if @tweets.lastObject
    }
  end

  def get_tweets(params = {})
    url = "http://search.twitter.com/search.json?q=RubyMotion"
    url.concat "&max_id=#{params[:max_id]}" if params[:max_id]
    url.concat "&since_id=#{params[:since_id]}" if params[:since_id]
    puts "Will download #{url}"

    Dispatch::Queue.concurrent.async do 
      json = nil
      begin
        json = JSONParser.parse_from_url(url)
      rescue RuntimeError => e
        presentError e.message
      end

      new_tweets = []
      json['results'].each do |dict|
        new_tweets << Tweet.new(dict)
      end

      unless new_tweets.empty?
        if params[:max_id]
          # On infinite scroll, append new tweets to the end
          @tweets += new_tweets
        elsif params[:since_id]
          # On pull to refresh, keep new tweets at the top
          @tweets.unshift(new_tweets)
        else
          @tweets = new_tweets
        end 
      end

      Dispatch::Queue.main.sync do
        view.reloadData
        # NOTE stop loading spinner
        doneReloadingTableViewData
      end
    end
  end

  def reload_tweets(tweets)
    @tweets = tweets
  end
 
  def presentError(error)
    # TODO
    $stderr.puts error.description
  end
 
  def tableView(tableView, numberOfRowsInSection:section)
    @tweets.size
  end

  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    TweetCell.heightForTweet(@tweets[indexPath.row], tableView.frame.size.width)
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    tweet = @tweets[indexPath.row]
    TweetCell.cellForTweet(tweet, inTableView:tableView)
  end
  
  def reloadRowForTweet(tweet)
    row = @tweets.index(tweet)
    if row
      view.reloadRowsAtIndexPaths([NSIndexPath.indexPathForRow(row, inSection:0)], withRowAnimation:false)
    end
  end

  # Pull to refresh

  def refreshTableHeaderDidTriggerRefresh(view)
    # NOTE pull to refresh action
    get_tweets(since_id: @tweets.first.id) if @tweets.first
  end

end

