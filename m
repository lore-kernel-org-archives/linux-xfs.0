Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A6D227F3F
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 14:24:22 -0500 (CDT)
Message-ID: <51F17B65.1090600@sgi.com>
Date: Thu, 25 Jul 2013 14:24:21 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 13/49] xfs: move unrealted definitions out of xfs_inode.h
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-14-git-send-email-david@fromorbit.com>
In-Reply-To: <1374215120-7271-14-git-send-email-david@fromorbit.com>
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

On 07/19/13 01:24, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---
>   fs/xfs/xfs_ialloc.c     |  1 +
>   fs/xfs/xfs_icache.h     |  7 +++++++
>   fs/xfs/xfs_inode.h      | 38 --------------------------------------
>   fs/xfs/xfs_log_format.h |  8 ++++++++
>   4 files changed, 16 insertions(+), 38 deletions(-)
>

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
