Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4B0637F37
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 14:17:19 -0500 (CDT)
Message-ID: <51F179BE.4040506@sgi.com>
Date: Thu, 25 Jul 2013 14:17:18 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 14/49] xfs: introduce xfs_inode_buf.c for inode buffer
	operations
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-15-git-send-email-david@fromorbit.com>
In-Reply-To: <1374215120-7271-15-git-send-email-david@fromorbit.com>
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
> The only thing remaining in xfs_inode.[ch] are the operations that
> read, write or verify physical inodes in their underlying buffers.
> Move all this code to xfs_inode_buf.[ch] and so we can stop sharing
> xfs_inode.[ch] with userspace.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Bug patches committed in the last couple days make this patch no longer 
current.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
