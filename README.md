# Papertrail Pushbullet Webhook

A simple webhook to send log messages to Pushbullet to provide simple iOS/Android/Chrome
notifications.

## Deploying

### Step 1: Create a heroku app

    $ heroku create

### Step 2: Get a Pushbullet API key

From https://docs.pushbullet.com/

### Step 3: Add API key to your heroku app

    $ heroku config:add PUSHBULLET_TOKEN=...

### Step 4: Add a secret endpoint to your heroku app

    $ heroku config:add SECRET=1234567890

This secret var will be used in the next step in the webhook URL.
    
### Step 4: Create a Papertrail saved search

1. Create a saved search for a unique term (something like `ops-alert` would work)
2. Create a search alert (webhook) pointing to your heroku app pointing to `/webhook/<secret>`

Find out more about search alerts and webhooks here: http://help.papertrailapp.com/kb/how-it-works/web-hooks

## Using

Once you've created a saved search in Papertrail and configured the search
alert, you can now send log messages that match that message.

For example, if your saved search matches `ops-alert`, you could use this 
to alert you when a big transfer has completed:

    $ rsync -R /backup backup:/backup ; logger -t ops-alert The transfer has completed
