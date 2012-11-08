Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA8GAFSG005054 for <xfs@oss.sgi.com>; Thu, 8 Nov 2012 10:10:15 -0600
Date: Thu, 8 Nov 2012 10:12:10 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: report projid32bit feature in geometry call
Message-ID: <20121108161210.GK9783@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1351816724-3000-7-git-send-email-david@fromorbit.com>
	<20121102032312.GW29378@dastard>
	<1351816724-3000-5-git-send-email-david@fromorbit.com>
	<1351816724-3000-4-git-send-email-david@fromorbit.com>
	<507476F1.3080503@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Oct 09, 2012 at 02:11:45PM -0500, Eric Sandeen wrote:
> When xfs gained the projid32bit feature, it was never added to
> the FSGEOMETRY ioctl feature flags, so it's not queryable without
> this patch.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

committed to git://oss.sgi.com/xfs/xfs.git, master and for-next branches.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
