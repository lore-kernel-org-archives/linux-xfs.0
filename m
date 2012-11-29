Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qATLf2aa087046 for <xfs@oss.sgi.com>; Thu, 29 Nov 2012 15:41:02 -0600
Message-ID: <50B7D6F7.4090309@sgi.com>
Date: Thu, 29 Nov 2012 15:43:19 -0600
From: Andrew Dahl <adahl@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: update XFS_IOC_ZERO_RANGE byte range test output
References: <1354163243-16916-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1354163243-16916-1-git-send-email-david@fromorbit.com>
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

On 11/28/2012 10:27 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Kernel code now does true byte range zeroing. Update the tests to
> validate true byte range zeroing correctly.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good!

Reviewed-by: Andrew Dahl <adahl@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
