Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3G4g7X8044536 for <xfs@oss.sgi.com>; Wed, 15 Apr 2009 23:42:17 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ED99C1426272
	for <xfs@oss.sgi.com>; Wed, 15 Apr 2009 21:43:42 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id tXShTf91KdNg19DJ for
	<xfs@oss.sgi.com>; Wed, 15 Apr 2009 21:43:42 -0700 (PDT)
Message-ID: <49E6B6F7.6030500@sandeen.net>
Date: Wed, 15 Apr 2009 23:41:27 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: future of xfs, oss.sgi.com after sgi purchased?
References: <49E65044.8080802@tlinx.org>
In-Reply-To: <49E65044.8080802@tlinx.org>
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
To: "Linda A. Walsh" <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Linda A. Walsh wrote:
> Not one to beat about the bush, but curious from a practical sense,
> 
> If sgi is being bought by another company, is there any idea about the plans
> for the xfs file system or the source code on 'oss.sgi.com'?
> 
> I'm _guessing_ that there is some interest in users and developers to keep xfs 
> alive after the 'sgi' moniker is purchased, but that begs the question about the 
> new company wanting to support the old 'sgi.com' websites including
> oss.sgi.com.
> 
> Is there a danger of oss.sgi.com suddenly being yanked offline with little to no 
> warning, such that community members should start keeping up-to-date, or is it 
> already mirrored?  I'm assuming that the current source code repository only 
> exists on oss.sgi.com?  Should it be mirrored on some other external open-source 
> site?  sourceforge? google? mozilla?

While I doubt that oss.sgi.com would abruptly vanish, there are
nonetheless already git repos on kernel.org, which are sometimes even
ahead of what's on oss.sgi.com ... xfs.org has a lot of content as well.
 Mailing list archives exist at various other sites.

There are also ftp mirrors around, though I think that's less important.

> Is completely worthless to discuss new, desired features in some of the utils? 
> Will it be possible to support the xfs codebase if its development no longer 
> becomes necessary to sgi (or its parent company)?

If you look at commit logs or carefully read the mailing list over the
last 6 months or so, I think you'll find that xfs maintenance and
development is not wholly dependent on contributions from sgi employees.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=history;f=fs/xfs;hb=HEAD

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
