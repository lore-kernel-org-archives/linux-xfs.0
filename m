Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 268F47FB6
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2014 16:23:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0AEFC8F80B5
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2014 14:23:26 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	p3lD35eSLc4wMleS for <xfs@oss.sgi.com>;
	Thu, 03 Apr 2014 14:23:24 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1WVp6Y-0002uH-L0
	for xfs@oss.sgi.com; Fri, 04 Apr 2014 08:23:22 +1100
Date: Fri, 4 Apr 2014 08:23:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [XFS updates] XFS development tree branch, for-next, updated.
	xfs-for-linus-v3.14-rc1-2-12968-ga6cf33b
Message-ID: <20140403212322.GO17603@dastard>
References: <20140403211643.00BE629DF9@oss.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140403211643.00BE629DF9@oss.sgi.com>
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

On Thu, Apr 03, 2014 at 04:16:41PM -0500, xfs@oss.sgi.com wrote:
> This is an automated email from the git hooks/post-receive script. It was
> generated because a ref change was pushed to the repository containing
> the project "XFS development tree".
> 
> The branch, for-next has been updated
>   a6cf33b Merge branch 'xfs-bug-fixes-for-3.15-3' into for-next
>   c88547a xfs: fix directory hash ordering bug
>   805eeb8 xfs: extra semi-colon breaks a condition
>       from  fe986f9d88ab8079c91669b7f175081f15491a80 (commit)
> 
> Those revisions listed above that are new to this repository have
> not appeared on any other notification email; so we list those
> revisions in full, below.

Folks, this is the branch I plan to tag and send to Linus to pull
tomorrow morning. It would be appreciated if people can run eyes
over it and test it before I do that.

FWIW, I plan to get all the other DIO/getblocks data corruption
issues sorted out and send them as a separate pull request (possibly
for -rc2) once they have had further testing.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
