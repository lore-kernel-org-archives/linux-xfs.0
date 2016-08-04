Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8BBB37CA0
	for <xfs@oss.sgi.com>; Thu,  4 Aug 2016 06:34:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5D126304032
	for <xfs@oss.sgi.com>; Thu,  4 Aug 2016 04:34:13 -0700 (PDT)
Received: from mail-wm0-f66.google.com (mail-wm0-f66.google.com
	[74.125.82.66]) by cuda.sgi.com with ESMTP id 0jefqO8HfHboOfLZ
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 04 Aug 2016 04:34:11 -0700 (PDT)
Received: by mail-wm0-f66.google.com with SMTP id x83so43252538wma.3
	for <xfs@oss.sgi.com>; Thu, 04 Aug 2016 04:34:11 -0700 (PDT)
Message-ID: <3D58B7EB9A964054997E0E370C98251D@dinulap>
From: "Lista Unx" <lista.unx@gmail.com>
References: <4278AB9734C1445A8E48635B155149F8@dinulap><57CF7681619F42CCB4C0CF589E9686E5@dinulap><alpine.LSU.2.20.1608031453290.5594@Grypbagne.inyvabe><4382687.Pe7d1tBhVA@merkaba><9b25f9f9-8a55-8744-9f18-c1045fae0f79@telefonica.net>
	<20160803231529.GX16044@dastard>
Subject: Re: Spam on this list
Date: Thu, 4 Aug 2016 14:34:11 +0300
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, "Carlos E. R." <robin.listas@telefonica.net>
Cc: XFS mail list <xfs@oss.sgi.com>


----- Original Message ----- 
From: "Dave Chinner" <david@fromorbit.com>
To: "Carlos E. R." <robin.listas@telefonica.net>
Cc: "XFS mail list" <xfs@oss.sgi.com>
Sent: Thursday, August 04, 2016 2:15 AM
Subject: Re: Spam on this list


> Yes, that is the fundamental issue - spam filtering is essentially
> controlled by SGI's internal infrastructure, which we have little
> option on.
>
> What it comes down to is whether we continue to use this list
> (xfs@oss.sgi.com) or whether we move to linux-xfs@vger.kernel.org
> so we get much more robust and up-to-date spam filtering. The issue
> with doing this is forcing everyone to resubscribe, and then
> capturing everything that is still sent to xfs@oss.sgi.com.
>
> That said, I'm seriously tempted right now just to say "we're moving
> to vger" and asking everyone to resubscribe to that list, and then
> making xfs@oss.sgi.com respond with "list moved to vger, please
> repost there". i.e. not even put a forwarding gateway in place.
>
> If we do that, then I'll also shut down all the XFS git trees on
> oss.sgi.com - I'll add commits to the them to say "go to
> kernel.org". I'll need to work something out for the tarball
> releases, but kernel.org does have functionality for that, too, so
> that may just be a small change of process on my end (i.e. use kup).
> Once that is done, we'll be running completely on community provided
> infrastructure....
>
> Thoughts?

I completely agree, is a good idea to move to a new place where more filters 
are already in place. It is a small change on user's side and benefits are 
for everyone. I cannot see any cons to not do it. It probably will be the 
best to keep also a message for newcommers and also for robots, that list 
has been moved to vger and new way to subscribe. 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
