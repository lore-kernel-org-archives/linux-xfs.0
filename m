Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p121QQK6256950 for <xfs@oss.sgi.com>; Tue, 1 Feb 2011 19:26:26 -0600
Subject: Re: [PATCH 1/4] xfstests: add simple splice test
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1295927937-20634-2-git-send-email-david@fromorbit.com>
References: <1295927937-20634-1-git-send-email-david@fromorbit.com>
	<1295927937-20634-2-git-send-email-david@fromorbit.com>
Date: Tue, 01 Feb 2011 19:28:50 -0600
Message-ID: <1296610130.2350.155.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

On Tue, 2011-01-25 at 14:58 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We don't have any coverage of the splice functionality provided by
> the kernel in xfstests. Add a simple test that uses the sendfile
> operation built into xfs_io to copy a file ensure we at least
> execute the code path in xfstests.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
