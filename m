Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6RLb0Jk257541 for <xfs@oss.sgi.com>; Fri, 27 Jul 2012 16:37:00 -0500
Message-ID: <501309FB.6080406@sgi.com>
Date: Fri, 27 Jul 2012 16:36:59 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v5 4/4]xfs: xfs_seek_hole() refinements with lookup hole
	offset from page cache.
References: <50110636.2010602@oracle.com> <50116326.6080701@oracle.com>
In-Reply-To: <50116326.6080701@oracle.com>
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

On 07/26/12 10:32, Jeff Liu wrote:
> Search possbile hole offset for given range from page cache for
> unwritten and delayed-allocation extents.
>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>

Same comments about the comments that I made in xfs_seek_data().

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
