Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8EGOUtb135477 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 11:24:31 -0500
Received: from kuber.nabble.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5CD4E1E65F8F
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 09:25:18 -0700 (PDT)
Received: from kuber.nabble.com (kuber.nabble.com [216.139.236.158]) by
	cuda.sgi.com with ESMTP id AIN1Gz7WceZB4Ll5 for
	<xfs@oss.sgi.com>; Tue, 14 Sep 2010 09:25:18 -0700 (PDT)
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>) id 1OvYJp-00038B-Al
	for xfs@oss.sgi.com; Tue, 14 Sep 2010 09:25:17 -0700
Message-ID: <29710388.post@talk.nabble.com>
Date: Tue, 14 Sep 2010 09:25:17 -0700 (PDT)
From: pbrunnen <PBrunnen@bccnetworks.net>
Subject: Re: XFS Filesystem not mounting
In-Reply-To: <201009141603.24754@zmi.at>
MIME-Version: 1.0
References: <29704010.post@talk.nabble.com> <20100914012151.GF411@dastard>
	<29705139.post@talk.nabble.com> <201009140740.14482@zmi.at>
	<20100914082504.4109712d@galadriel.home>
	<29708085.post@talk.nabble.com> <201009141603.24754@zmi.at>
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



Michael Monnerie-5 wrote:
> 
> And did it work out finally? Was a destroyed log the problem?
> 

Thankfully, yes.  Only minor damage. -- stat logs being updated at the time
of failure.


Michael Monnerie-5 wrote:
> 
> I'm currently on 11.2, and must say it's the best I ever worked with. 
> Especially upgrading is so fast, smooth and easy now (in-place upgrade) 
> that it really makes fun. Didn't have time to upgrade to 11.3, I just 
> did a fresh install of it once and it looked even better (desktop 
> version on a notebook).
> 

No doubt on the desktop/laptop side of things.  I am on the server side and
the little things that I used to love (full automation of chroot jails for
daemons, etc) have really been geared now for end users (network manager)
and less for servers.  Can't blame them... they want to sell SLES.

Ah well... Its been over a year and I still can't make up my mind.  :-P

Thanks!  -Cheers, Peter.
-- 
View this message in context: http://old.nabble.com/XFS-Filesystem-not-mounting-tp29704010p29710388.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
