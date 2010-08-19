Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7JDsefg174604 for <xfs@oss.sgi.com>; Thu, 19 Aug 2010 08:54:41 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 448BF1E4C8A9
	for <xfs@oss.sgi.com>; Thu, 19 Aug 2010 06:55:10 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id F9A181LZgELZPL8L
	for <xfs@oss.sgi.com>; Thu, 19 Aug 2010 06:55:10 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 71CDA6C2D0
	for <xfs@oss.sgi.com>; Thu, 19 Aug 2010 08:55:10 -0500 (CDT)
Message-ID: <4C6D37BD.3060900@hardwarefreak.com>
Date: Thu, 19 Aug 2010 08:55:09 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: LWN.net article: creating 1 billion files -> XFS looses
References: <201008191312.49346@zmi.at> <20100819120512.GB9358@infradead.org>
	<201008191445.22568@zmi.at>
In-Reply-To: <201008191445.22568@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Michael Monnerie put forth on 8/19/2010 7:45 AM:
> Just this week I had a friend in a FS 
> discussion saying "ins't XFS destroying/zeroing files on power 
> failure?". That information is ancient, but things like that stay in 
> peoples brain for(almost)ever.

Had a similar lengthy discussion over on debian-users not more than a month or
so ago.  Same thing there.  Of the 10 or so people active in the thread, I'd
say 8 of them were anti-XFS because of the "corruption  due to power failure"
issue that they'd "read about" years before.  Not a single one of them had
ever used XFS.  A couple of them considered it a "hobbyist quality" filesystem
that might be ready for production use in a few years.  Ahh the ignorance
abounds in our world...

I did my best to educate them, sending them to the Wikipedia page on XFS and
to the xfs.org site and specifically the relevant sections of the FAQ.
Unfortunately there are some people who simply refuse to be educated.  But
those type of people aren't candidates for XFS anyway, thankfully. ;)

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
