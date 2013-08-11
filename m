Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6C3877CBE
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 18:31:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 08874AC002
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 16:31:04 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	DMVGaBHlXNTQ3JAm for <xfs@oss.sgi.com>;
	Sun, 11 Aug 2013 16:31:03 -0700 (PDT)
Date: Mon, 12 Aug 2013 09:31:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** Re: [PATCH 7/14] xfsprogs: fix issues with
	commit 75c8b4343abb
Message-ID: <20130811233101.GD12779@dastard>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<20130806214154.GM3111@sgi.com> <20130808210600.GN3111@sgi.com>
	<20130808213356.GU3111@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130808213356.GU3111@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Thu, Aug 08, 2013 at 04:33:56PM -0500, Ben Myers wrote:
> These are various issues found in 75c8b4343abb during review.
> * clean up a few extra tabs
> * xfs_buf_map->xfs_buf_ops in libxfs_readbuf and libxfs_readbuf_map args
> * don't call the write verifier twice
> * put the multithreaded scan_ags back
> 
> Signed-off-by: Ben Myers <bpm@sgi.com>

Needs a better subject, say, "clean up libxfs buffer read/write
code"?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
