Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1CB487F56
	for <xfs@oss.sgi.com>; Fri,  2 Aug 2013 11:25:49 -0500 (CDT)
Message-ID: <51FBDD89.7070803@sgi.com>
Date: Fri, 02 Aug 2013 11:25:45 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 10/49] libxfs: sync dir2 kernel differences
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
	<1374216324-8781-11-git-send-email-david@fromorbit.com>
In-Reply-To: <1374216324-8781-11-git-send-email-david@fromorbit.com>
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
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

syncs the libxfs/xfs_dir2.c, libxfs/xfs_dir2_data.c, 
libxfs/xfs_dir2_leaf.c, and libxfs/xfs_dir2_node.c to the Linux 3.12 
series before kernel patch 31/49.

Reviewed-by: Mark Tinguely: <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
