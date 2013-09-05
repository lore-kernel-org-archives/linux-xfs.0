Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AF4557F58
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 10:52:34 -0500 (CDT)
Message-ID: <5228A8C1.2000102@sgi.com>
Date: Thu, 05 Sep 2013 10:52:33 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 07/55] libxfs: sync xfs_da_btree.c
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
	<1378332359-14737-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-8-git-send-email-david@fromorbit.com>
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

On 09/04/13 17:05, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Some variables we renamed in the kernel code, and there are a few
> other minor differences. Fix them up.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Opps put patch 8 comment on patch 7.

This also did not change in this repost. And the patch really

changed variable names in xfs_da3_node_unbalance().
add directory allocation NOFS per kernel commit b17cb364

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
