'''

This script will tweet!

https://codingdose.info/2018/03/01/How-to-send-a-tweet-with-Python-using-Tweepy/

sudo pip3 install tweepy
sudo pip3 install python-dotenv
'''


from os import getenv
from dotenv import load_dotenv #, find_dotenv
import tweepy


new_tweet = 'Euronext company with the highest open short interest? Fugro! http://www.shortinterest.eu #euronext #shortinterest #fugro'


# load env keys
load_dotenv('twitter.env')

consumer_key = getenv('consumer_key')
consumer_secret = getenv('consumer_secret')
access_token = getenv('access_token')
access_secret = getenv('access_secret')
#print(consumer_key,consumer_secret,access_token,access_secret)


# authentication with OAuth using our keys
auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_secret)

# return an API using our previous access
api = tweepy.API(auth)

# send a tweet
api.update_status(new_tweet)
print('Tweet sent.')
