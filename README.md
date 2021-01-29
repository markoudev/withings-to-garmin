# Withings to Garmin weight synchronization

A very ugly way to synchronize Withings weight information with Garmin. I built
this primarily for myself, so it may be interesting to use as a base but
probably not much more than that. It's also not my most beautiful code.

Unfortunately, Garmin doesn't provide us with a way to nicely upload health
data to your account using an API of some sorts. Yes, you can apply for one, but
you'll have to be accepted and everything. It's pretty disappointing. But
luckily we can borrow a concept from end-to-end testing where we just fire up
a headless browser to do the clicks for us, and upload a CSV file that way.

Before you can use this, you'll need to register an application with Withings.
You can do so, by [logging in to your account and register your application](https://account.withings.com/partner/account_login?b=add_oauth2).

The Dockerfile is here for my own convenience, so I can easily run the
application on another machine.

If you're looking for a way to synchronize all of your Withings data to Garmin
Connect, have a look at [jaroslawhartman/withings-sync](https://github.com/jaroslawhartman/withings-sync).
