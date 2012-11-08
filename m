Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA8GDkDI005270 for <xfs@oss.sgi.com>; Thu, 8 Nov 2012 10:13:46 -0600
Date: Thu, 8 Nov 2012 10:15:44 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 0/6] xfs: fixes for 3.7-rc3
Message-ID: <20121108161544.GL9783@sgi.com>
References: <1351816724-3000-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1351816724-3000-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Nov 02, 2012 at 11:38:38AM +1100, Dave Chinner wrote:
> Here are my current outstanding fixes that are candidates for 3.7.
> Patches 2 and 3 are the initial fixes from the verifier series (real
> bugs) and the other are regressions that I've recently fixed. Some
> need to be sent back to stable kernels as well and are tagged as
> such.

Thanks for reposting.  Some of these I didn't have in my queue.

I've committed the patches in this seres to git://oss.sgi.com/xfs/xfs.git,
master and for-next branches, with v2 of patch 5.  I'll do a pull request asap.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
