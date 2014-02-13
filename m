Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6D52629DFD
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 16:45:46 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 416398F8033
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 14:45:46 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	V0yigibDiBV0nbRi for <xfs@oss.sgi.com>;
	Thu, 13 Feb 2014 14:45:44 -0800 (PST)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1WE52H-0004sW-Df
	for xfs@oss.sgi.com; Fri, 14 Feb 2014 09:45:37 +1100
Date: Fri, 14 Feb 2014 09:45:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [XFS updates] XFS development tree branch, for-next, updated.
	xfs-for-linus-v3.14-rc1-2-12935-ga64b760
Message-ID: <20140213224537.GL13997@dastard>
References: <20140213223525.B7E517F57@oss.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140213223525.B7E517F57@oss.sgi.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On Thu, Feb 13, 2014 at 04:35:24PM -0600, xfs@oss.sgi.com wrote:
> This is an automated email from the git hooks/post-receive script. It was
> generated because a ref change was pushed to the repository containing
> the project "XFS development tree".
> 
> The branch, for-next has been updated
>   discards  39f30ca7eaa4fe9224094c7a9964cff36c584dab (commit)
>   discards  008482657169c0276ddd2ba00a1ad14a324b91f0 (commit)
>   a64b760 Merge branch 'xfs-async-aio-extend' into for-next
>   692f68a Merge branch 'xfs-fixes-for-3.15-1' into for-next
>   55daffa xfs: xfs_sb_read_verify() doesn't flag bad crcs on primary sb
>       from  39f30ca7eaa4fe9224094c7a9964cff36c584dab (commit)
> 
> Those revisions listed above that are new to this repository have
> not appeared on any other notification email; so we list those
> revisions in full, below.

Just a note for everyone because this is the first time it has
happened since this discussion:

http://oss.sgi.com/archives/xfs/2013-12/msg00586.html

This update is a rebase of the for-next branch as the initial topic
branch that forms the current base of the for-next tree
(xfs-fixes-for-3.14-rc3) was updated. The commit 55daffa mentioned
above is the new commit that was added to that that branch.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
