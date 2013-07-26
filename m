Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 578DE29E21
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 14:33:15 -0500 (CDT)
Message-ID: <51F2CEFA.1040907@sgi.com>
Date: Fri, 26 Jul 2013 14:33:14 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 25/49] xfs: consolidate xfs_rename.c
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-26-git-send-email-david@fromorbit.com>
In-Reply-To: <1374215120-7271-26-git-send-email-david@fromorbit.com>
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
> Move the rename code to xfs_inode.c to continue consolidating
> all the kernel xfs_inode operations in the one place.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Simple copy of the xfs_rename functions to xfs_inode.c
Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
