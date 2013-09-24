Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 85AE77F4E
	for <xfs@oss.sgi.com>; Tue, 24 Sep 2013 11:13:43 -0500 (CDT)
Message-ID: <5241BA37.3020507@sgi.com>
Date: Tue, 24 Sep 2013 11:13:43 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 4/5] xfs: fix XFS_IOC_FREE_EOFBLOCKS definition
References: <1380002476-18839-1-git-send-email-david@fromorbit.com>
	<1380002476-18839-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1380002476-18839-5-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 09/24/13 01:01, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> It uses a kernel internal structure in it's definition rather than
> the user visible structure that is passed to the ioctl.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
