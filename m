Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2DE0D7F37
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 07:29:53 -0500 (CDT)
Message-ID: <51937FDB.2090906@sgi.com>
Date: Wed, 15 May 2013 07:30:19 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests btrfs/284: shorten duration, fix output
References: <517ACB41.2030002@redhat.com>
In-Reply-To: <517ACB41.2030002@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Liu Bo <liubo2009@cn.fujitsu.com>, linux-btrfs <linux-btrfs@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On 04/26/2013 01:45 PM, Eric Sandeen wrote:
> test 284 had... some issues.
>

> diff --git a/tests/btrfs/284 b/tests/btrfs/284
> old mode 100644
> new mode 100755
> index d952977..67161a3
> --- a/tests/btrfs/284
> +++ b/tests/btrfs/284

>
This patch has been committed:

commit 91f87e3b89c0f7350a56d397ba7255d0e3d6b486
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Wed May 15 07:18:07 2013 -0500

     xfstests btrfs/284: shorten duration, fix output

     Signed-off-by: Eric Sandeen <sandeen@redhat.com>
     Reviewed-by: Josef Bacik <jbacik@fusionio.com>
     Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
