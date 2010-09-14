Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8ECVGIG125520 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 07:31:16 -0500
Received: from kuber.nabble.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6037C17EFB14
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 05:32:03 -0700 (PDT)
Received: from kuber.nabble.com (kuber.nabble.com [216.139.236.158]) by
	cuda.sgi.com with ESMTP id B6lgqz5dDHInVvmb for
	<xfs@oss.sgi.com>; Tue, 14 Sep 2010 05:32:03 -0700 (PDT)
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>) id 1OvUg7-0007P5-Ck
	for xfs@oss.sgi.com; Tue, 14 Sep 2010 05:32:03 -0700
Message-ID: <29708085.post@talk.nabble.com>
Date: Tue, 14 Sep 2010 05:32:03 -0700 (PDT)
From: pbrunnen <PBrunnen@bccnetworks.net>
Subject: Re: XFS Filesystem not mounting
In-Reply-To: <20100914082504.4109712d@galadriel.home>
MIME-Version: 1.0
References: <29704010.post@talk.nabble.com> <20100914012151.GF411@dastard>
	<29705139.post@talk.nabble.com> <201009140740.14482@zmi.at>
	<20100914082504.4109712d@galadriel.home>
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


Hello all...
   First and foremost I want to say Thank You to everyone for the sounding
board.  Yesterday was a bit panicky for me.  ;-)

   Time was not my friend and I ended up having to try the route that
Emmanuel suggested by rebuilding the log with "xfs_repair -L"...   Tried to
avoid it until the end.


Hi Dave,
  Yea... that was supposed to be 2.6.18...  I really like to date myself. 
;-)
I will keep note of that command though... If I ever see this again I can
get the right info faster.


Hi Michael,
  Yes, its based on 10.2...  The kernel is one of the only things not
updated.  I really don't like the newer builds of SuSE as much and have been
reluctant to upgrade.  I am considering to build a newer kernel or switch to
debian.


Again Thank you Dave, Michael, and Emmanuel for your input!
Your time is Very Much appreciated.  :-)

-Cheers, Peter.
-- 
View this message in context: http://old.nabble.com/XFS-Filesystem-not-mounting-tp29704010p29708085.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
