AmpacheClient
=============

This project came to life mostly because I wanted to learn Swift and Cocoa Touch. It is not available on the Apple App Store.

AmpacheClient is... well... a simple client for the more or less well known Ampache music server. I did most testing against the Owncloud music addon that provides a (currently small) subset of the Ampache API. Especially it cannot do cover art yet, so no covers in here, too.

What works
----------

- Streaming single tracks
- Adding more tracks to the player's internal playlist
- Using an MPVolumeView to regulate the volume! Probably.
	- Unfortunately, I couldn't test this yet as I don't currently have signing keys for this app. Besides, the intarwebz (tm) says MPVolumeView only works directly on the device (instead of the simulator). I had a simple slider before that regulated the volume just fine but couldn't do any AirPlay magic.

What doesn't
------------

- Viewing or editing the playlist
- Entering the server's URL directly on the device (Hardcoded for now. Sorry. :))

License
-------

Everything I did here was possible because of the Apple Docs (obviously) and the help of the incredible community over at stackoverflow.com. Do with it whatever you feel like.
