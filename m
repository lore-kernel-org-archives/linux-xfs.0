Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 432DF29DF8
	for <xfs@oss.sgi.com>; Mon, 30 Dec 2013 12:21:42 -0600 (CST)
Message-ID: <52C1B9B8.5080403@sgi.com>
Date: Mon, 30 Dec 2013 12:21:44 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/10] xfs: remove redundant stat assignment int
	xfs_bulkstat_one_int
References: <52BEB3DF.8080901@oracle.com>
In-Reply-To: <52BEB3DF.8080901@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 12/28/13 05:19, Jeff Liu wrote:
> From: Jie Liu<jeff.liu@oracle.com>
>
> Trivial fix to get rid of redundant BULKSTAT_RV_NOTHING assignment
> in xfs_bulkstat_one_int().
>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
> ---

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
