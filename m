Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EED767F52
	for <xfs@oss.sgi.com>; Fri,  2 Aug 2013 09:22:43 -0500 (CDT)
Message-ID: <51FBC0B0.9020002@sgi.com>
Date: Fri, 02 Aug 2013 09:22:40 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 07/49] libxfs: sync xfs_da_btree.c
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
	<1374216324-8781-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1374216324-8781-8-git-send-email-david@fromorbit.com>
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

On 07/19/13 01:44, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Some variables we renamed in the kernel code, and there are a few
> other minor differences. Fix them up.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

changed variable names in xfs_da3_node_unbalance().
add directory allocation NOFS per kernel commit b17cb364

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
