Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 59B937F51
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 13:56:36 -0500 (CDT)
Message-ID: <5228D3E3.5040300@sgi.com>
Date: Thu, 05 Sep 2013 13:56:35 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 15/55] libxfs: local to remote format support of remote
	symlinks
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
	<1378332359-14737-16-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-16-git-send-email-david@fromorbit.com>
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
> This conversion was overlooked earlier on. Now that the differences
> between userspace and kernel space are getting smaller this bug is
> obvious. Fix it.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

This reposted patch has not changed.

same content for xfs_symlink_local_to_remote() as kernel commit f948dd76 
and moved from xfs_bmap.c to xfs_symlink.c

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
