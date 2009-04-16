Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3G8YtAu064742 for <xfs@oss.sgi.com>; Thu, 16 Apr 2009 03:35:05 -0500
Received: from ishtar.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A3A3A21AFC2
	for <xfs@oss.sgi.com>; Thu, 16 Apr 2009 01:34:17 -0700 (PDT)
Received: from ishtar.tlinx.org (ishtar.tlinx.org [64.81.245.74]) by
	cuda.sgi.com with ESMTP id AfFp7GZAYdrOHXZM for
	<xfs@oss.sgi.com>; Thu, 16 Apr 2009 01:34:17 -0700 (PDT)
Received: from [192.168.3.11] (Athena [192.168.3.11])
	by ishtar.tlinx.org (8.14.1/8.12.10/SuSE Linux 0.7) with ESMTP id
	n3G8YHen021912 for <xfs@oss.sgi.com>; Thu, 16 Apr 2009 01:34:17 -0700
Message-ID: <49E6ED88.5020008@tlinx.org>
Date: Thu, 16 Apr 2009 01:34:16 -0700
From: "Linda A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: future of xfs, oss.sgi.com after sgi purchased?
References: <49E65044.8080802@tlinx.org> <49E6B6F7.6030500@sandeen.net>
In-Reply-To: <49E6B6F7.6030500@sandeen.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:
> Linda A. Walsh wrote:
> > If sgi is being bought by another company, is there any idea about the plans
> > for the xfs file system or the source code on 'oss.sgi.com'?
>
> While I doubt that oss.sgi.com would abruptly vanish, there are
> nonetheless already git repos on kernel.org, which are sometimes even
> ahead of what's on oss.sgi.com ... xfs.org has a lot of content as well.
>  Mailing list archives exist at various other sites.
---
    Would hope not -- but have seen companies pull real bonehead maneuvers.

I can understand that for kernel work, but what about the xfs utils? 
(dump/restore et al.)
They have had a pretty static feature set from what little I've noticed, but I 
may just not be
getting updates.  I don't know if it would be of any benefit, but apparently the 
sgi xfsdump used to be multi-threaded?  (Just as a random example).   Thanks for 
allaying some concerns.


Felix Blyakher wrote:
>> I'm _guessing_ that there is some interest in users and developers to 
>> keep xfs alive after the 'sgi' moniker is purchased, but that begs the 
>> question about the new company wanting to support the old 'sgi.com' 
>> websites including oss.sgi.com.
>>
>> Is there a danger of oss.sgi.com suddenly being yanked offline with 
>> little to no warning,
> 
> I doubt it'll happen in any circumstances.
---
    There have been precedents at sgi.  Other systems from sgi pulled on a 
policy change:
Internal news, external employee web-pages (reality being yanked).  All based on
some policy or organizational change that gave very little advance warning.

> I hope that wouldn't happen. Though, while it'll be loss for xfs
> in this unlikely scenario, I think, there is enough critical mass
> outside of sgi to continue support and move forward xfs.
---
    I'd like to think so, but for whatever reason(s), it's seems to be one of 
the larger
(in terms of lines of code) filesystems -- making more difficult to support -- 
not that
those lines aren't there for good use/good features.  Just that XFS was well 
developed
when it was being ported too linux.  Was no easy task.    I'd love to see XFS 
ported to the
Windows environment -- and then give MS some competition for their NT file system.
Since Fat32 has more significantly important limitations, Can't always use a 
FAT32 as a
common files system between OS's. And MS isn't exactly open about NTFS.

> Felix
> xfs maintainer, still at sgi
----
Congrats...on making this far...

-l

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
