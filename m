Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Aug 2006 14:53:57 -0700 (PDT)
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k71LrYDW002059
	for <linux-xfs@oss.sgi.com>; Tue, 1 Aug 2006 14:53:37 -0700
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1G829A-0002sY-E5
	for linux-xfs@oss.sgi.com; Tue, 01 Aug 2006 23:51:29 +0200
Received: from 1303ds1-by.0.fullrate.dk ([89.150.142.65])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Tue, 01 Aug 2006 23:51:28 +0200
Received: from asjo by 1303ds1-by.0.fullrate.dk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Tue, 01 Aug 2006 23:51:28 +0200
From: asjo@koldfront.dk (Adam =?iso-8859-1?Q?Sj=F8gren?=)
Subject: Re: Review: xfs_repair fixes for dir2 corruption
Date: Tue, 01 Aug 2006 23:50:14 +0200
Message-ID: <87ac6oruqx.fsf@topper.koldfront.dk>
References: <20060728091735.B2196410@wobbly.melbourne.sgi.com>
	<200607280155.LAA12814@larry.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

On Fri, 28 Jul 2006 11:58:52 +1000, Barry wrote:

> For those that are keen to fix the 16777216 problem, give this patch
> a go.

I thought that I'd just report that the patch worked flawlessly when I
applied it to xfsprogs from cvs and ran the the resulting xfs_repair
on my bad filesystem (see <87veqhfmo4.fsf@topper.koldfront.dk>,
<87fyhd1ek7.fsf@topper.koldfront.dk>).

I have another box (Intel P4) which had the problem, the patched
xfs_repair fixed its three bad filesystems as well.


  Thanks!

   Adam

-- 
 "Subdued flamboyance"                                        Adam Sjøgren
                                                         asjo@koldfront.dk
