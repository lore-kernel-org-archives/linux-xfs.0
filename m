Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8EGZArW135943 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 11:35:11 -0500
Received: from kuber.nabble.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 624C471154
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 09:35:59 -0700 (PDT)
Received: from kuber.nabble.com (kuber.nabble.com [216.139.236.158]) by
	cuda.sgi.com with ESMTP id GTadowMeP0t5isKl for
	<xfs@oss.sgi.com>; Tue, 14 Sep 2010 09:35:59 -0700 (PDT)
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>) id 1OvYUA-0004c1-Hg
	for xfs@oss.sgi.com; Tue, 14 Sep 2010 09:35:58 -0700
Message-ID: <29710491.post@talk.nabble.com>
Date: Tue, 14 Sep 2010 09:35:58 -0700 (PDT)
From: pbrunnen <PBrunnen@bccnetworks.net>
Subject: Re: XFS Filesystem not mounting
In-Reply-To: <4C8F9E29.2000803@hardwarefreak.com>
MIME-Version: 1.0
References: <29704010.post@talk.nabble.com> <20100914012151.GF411@dastard>
	<29705139.post@talk.nabble.com> <201009140740.14482@zmi.at>
	<20100914082504.4109712d@galadriel.home>
	<29708085.post@talk.nabble.com> <201009141603.24754@zmi.at>
	<4C8F9E29.2000803@hardwarefreak.com>
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


Hi Stan,


Stan Hoeppner wrote:
> 
> I've been using Debian for headless servers for many years.
> Distribution upgrades via apt-get or aptitude have been smooth and easy
> for many years.  I have one server that's been in-place upgraded from
> Woody through Lenny with only minor dependency issues--that's 4
> distribution upgrades over 5 years--Woody, Sarge, Etch, Lenny.
> 

Part of my reasoning for looking towards debian is because I was forced into
it about two years ago.  I manage a solution for one of my company partners
which is based on etch with backported kernels.  There are many things I
like about it... and I agree on the clean upgrade path and very good package
management.

But the downsides to debian have been holding me back...
1) I miss yast.  aptitude is just not the same.
2) Vendor support is officially non-existant.  We are a Dell shop and
upgrading openmanage is a pain. With SuSE its download and go.
3) I understand the ideology and legal reasons debian removes firmware blobs
(broadcom anyone) from their kernel modules...  but this is always a real
pain.  I end up monkeying about with the initrd image to get the firmware
blobs in... and often I just recompile with the blobs and forget it.


Stan Hoeppner wrote:
> 
> Then again, I don't use Debian kernels, so my kernels were never
> upgraded during the dist upgrade.  This may have prevented some
> headaches.  I roll my own kernels from kernel.org source and tend to
> keep fairly current.  So, when I do a dist upgrade my current kernel is
> usually newer than what the dist upgrade provides.  The fact I leave out
> features I don't need may play a role in preventing problems as well.
> 

;-)  That makes a huge difference.  But generally my experience thus far
with debian has been positive.  Enough to make me consider switching.   And
I know the XFS has never given me a lick of trouble.

*Didn't want to seem off topic.  Had to throw in the XFS reference at the
end.  lol.

Thanks again for everyone's input.
Its Much Appreciated!
-Cheers, Peter.
-- 
View this message in context: http://old.nabble.com/XFS-Filesystem-not-mounting-tp29704010p29710491.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
