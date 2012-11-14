Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAEJv6ER169698 for <xfs@oss.sgi.com>; Wed, 14 Nov 2012 13:57:06 -0600
Message-ID: <50A3F80C.7050502@sgi.com>
Date: Wed, 14 Nov 2012 13:59:08 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 02.5/32] xfs: remove xfs_tosspages
References: <1352721264-3700-1-git-send-email-david@fromorbit.com>
	<1352721264-3700-3-git-send-email-david@fromorbit.com>
	<20121114064247.GC1710@dastard> <50A3E807.5010403@sgi.com>
	<50A3E86A.2060402@sgi.com>
In-Reply-To: <50A3E86A.2060402@sgi.com>
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
To: Andrew Dahl <adahl@sgi.com>
Cc: xfs@oss.sgi.com

On 11/14/12 12:52, Andrew Dahl wrote:
>
> Reversing the check on XFS_IOC_ZERO_RANGE.
>
> Range should be zeroed if the start is less than or equal to the end.
>
> Signed-off-by: Andrew Dahl<adahl@sgi.com>
>
> ---

Tests correctly.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
