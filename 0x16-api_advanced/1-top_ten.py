#!/usr/bin/python3
"""
    scrript that gets the hottest 10
"""
from requests import get


def top_ten(subreddit):
    """
        function that queries the Reddit API
        and prints the titles of the first 10
        hot posts listed for a given subreddit
    """

    if subreddit is None or not isinstance(subreddit, str):
        print("None")

    user_agent = {'User-Agent': 'Google Chrome Version 117.0.5938.149'}
    url = "https://www.reddit.com/r/{}/hot/.json".format(subreddit)
    params = {'limit': 10}
    response = get(url, headers=user_agent, params=params)
    data = response.json()

    try:
        top_10 = data.get('data').get('children')
        for item in top_10:
            print(item.get('data').get('title'))
    except Exception:
        print("None")
