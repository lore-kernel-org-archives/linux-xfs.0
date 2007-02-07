Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 07 Feb 2007 11:32:00 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l17JVqm7031252
	for <xfs@oss.sgi.com>; Wed, 7 Feb 2007 11:31:53 -0800
Received: from localhost (localhost [127.0.0.1])
	by lucidpixels.com (Postfix) with ESMTP id 8F792A00226A
	for <xfs@oss.sgi.com>; Wed,  7 Feb 2007 14:31:51 -0500 (EST)
Date: Wed, 7 Feb 2007 14:31:51 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: xfs_growfs(?)
Message-ID: <Pine.LNX.4.64.0702071431300.29324@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Anyone know the answer to this one?

I have wondered the same thing.

---------- Forwarded message ----------
Date: Wed, 7 Feb 2007 12:16:55 -0600
From: "Discussion@SR" <webmaster@storagereview.com>
To: jpiszcz@lucidpixels.com
Subject: Topic Subscription Reply Notification ( Discussion@SR )

jpiszcz,

poodel has just posted a reply to a topic that you have subscribed to titled "RAID5 fileserver recommendations".

----------------------------------------------------------------------
QUOTE(jpiszcz @ Jan 3 2007, 12:08 PM) [snapback]237616[/snapback]

Growing the XFS filesystem is a breeze:

# xfs_growfs /raid5


-----------------------------



Just thought of one thing... when you add another disk to the set, doesn't that mess with the XFS parameters. Ideally, they would be tuned to your number of hard disks at creation time, but now they won't be?

Is there a way to tune the XFS after creation?
----------------------------------------------------------------------

The topic can be found here:
http://forums.storagereview.net/index.php?showtopic=24099&view=getnewpost



If you have configured in your control panel to recieve immediate topic reply notifications, you may receive an
email for each reply made to this topic.  Otherwise, only 1 email is sent per board visit for each subscribed topic.
This is to limit the amount of mail that is sent to your inbox.

Unsubscribing:
--------------

You can unsubscribe at any time by logging into your control panel and clicking on the "View Subscriptions" link.

Regards,

The Discussion@SR team.
http://forums.storagereview.net/index.php
