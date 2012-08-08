Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q78LLHFq069265 for <xfs@oss.sgi.com>; Wed, 8 Aug 2012 16:21:17 -0500
Message-ID: <5022D848.9050103@sgi.com>
Date: Wed, 08 Aug 2012 16:21:12 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v6 3/4] xfs: xfs_seek_data() refinement with lookup data
	buffer offset from page cache
References: <501B6B7B.5040602@oracle.com>
In-Reply-To: <501B6B7B.5040602@oracle.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: jeff.liu@oracle.com
Cc: xfs@oss.sgi.com

On 08/03/12 01:11, Jeff Liu wrote:
> Refine xfs_seek_data() to check up data buffer offset from page cache for unwritten extents.
>
>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
>
> ---

Looks great.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
