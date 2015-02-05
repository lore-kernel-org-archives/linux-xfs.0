Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 96E3A8017
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 17:37:37 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8466E304043
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 15:37:37 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	braYzCBwPzBgwZUd for <xfs@oss.sgi.com>;
	Thu, 05 Feb 2015 15:37:35 -0800 (PST)
Date: Fri, 6 Feb 2015 10:37:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/2] xfsprogs/repair: fix a couple large block size
	alignment issues
Message-ID: <20150205233720.GV4251@dastard>
References: <1423173023-54866-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1423173023-54866-1-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Feb 05, 2015 at 04:50:21PM -0500, Brian Foster wrote:
> Hi all,
> 
> This is just a couple fixes for issues I came across while playing with
> larger block and inode sizes on a ppc64 box...

Yup, fixes look sane. I'll test and pull them in.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
