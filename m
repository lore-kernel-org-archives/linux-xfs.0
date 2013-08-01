Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7268729DFB
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 13:07:17 -0500 (CDT)
Message-ID: <51FAA3D1.5030406@sgi.com>
Date: Thu, 01 Aug 2013 13:07:13 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 01/49] xfsprogs: introduce xfs_icreate.h
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
	<1374216324-8781-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1374216324-8781-2-git-send-email-david@fromorbit.com>
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
> Bring the new inode create item definitions across from kernel space
> for xfs_logprint to be able to parse.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

okay, sync with kernel commit 3ebe7d.

Reviewed-by: Mark Tinguely <tinguely.sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
