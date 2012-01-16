Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p984Bd3t102649 for <xfs@oss.sgi.com>; Fri, 7 Oct 2011 23:11:39 -0500
Message-ID: <4F144FDE.10900@sgi.com>
Date: Mon, 16 Jan 2012 10:27:10 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/8] xfstests: rename RETAIN_AG_BYTES
References: <1321875088-30801-1-git-send-email-david@fromorbit.com>
	<1321875088-30801-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1321875088-30801-4-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 01/-10/63 13:59, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Rename the $RETAIN_AG_BYTES variable to be more generic so that it
> reflects the fact that it is designed to retain a certain amount of
> extra free space above the default amount in the filesystem when
> doing large scratch device testing.
>

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
