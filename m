Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 97D0029DFC
	for <xfs@oss.sgi.com>; Tue, 24 Sep 2013 12:46:37 -0500 (CDT)
Date: Tue, 24 Sep 2013 12:46:33 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 0/5] xfs: fixes for 3.12-rc3
Message-ID: <20130924174633.GH1935@sgi.com>
References: <1380002476-18839-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1380002476-18839-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 24, 2013 at 04:01:11PM +1000, Dave Chinner wrote:
> These are fixes needed for regressions introduced in the 3.12 merge.
> I posted the first 3 patches a week ago, and sinve then I've found a
> couple more issues in working through all the xfstests failures I've
> been seeing since 3.12-rc1 was released.
> 
> The last patch in the series fixes a filesystem corruption bug, so
> getting these into -rc3 should be considered a priority....

Applied 2-5.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
