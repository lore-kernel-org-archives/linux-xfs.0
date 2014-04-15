Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1A99A7F3F
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 16:59:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1922A8F8054
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 14:59:46 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	UydC10ArImPAh5LN for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 14:59:45 -0700 (PDT)
Date: Wed, 16 Apr 2014 07:59:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 0/4] xfs: tmpfile fixes
Message-ID: <20140415215931.GQ15995@dastard>
References: <1397578706-5385-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397578706-5385-1-git-send-email-bfoster@redhat.com>
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

On Tue, Apr 15, 2014 at 12:18:22PM -0400, Brian Foster wrote:
> Hi all,
> 
> Here's a v3 series for the patches previously posted here:
> 
> http://oss.sgi.com/archives/xfs/2014-04/msg00181.html
> 
> Patches 1 and 2 are just a split-up of the v1 patch:
> 
> http://oss.sgi.com/archives/xfs/2014-04/msg00149.html
> 
> Note the v1 patch has a reviewed-by, so feel free to drop 1 and 2 here
> in favor of that version. Patches 3 and 4 are a couple cleanups in the
> xfs_create() path.

I've already got the orginal patch lined up for commit and have been
testing it for a couple of days, so I'll stick with the original.

The other two patches I'll add to the 3.16 queue as they aren't
really bug fixes....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
