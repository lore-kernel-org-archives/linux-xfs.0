Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E0F587FF0
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 04:09:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C906B304032
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 02:09:52 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	lk65aQJL8hQMFb62 for <xfs@oss.sgi.com>;
	Tue, 06 May 2014 02:09:50 -0700 (PDT)
Date: Tue, 6 May 2014 19:09:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/5 v2] xfs: pass struct da_args to xfs_attr_calc_size
Message-ID: <20140506090948.GK5421@dastard>
References: <1399130415-5382-1-git-send-email-hch@lst.de>
	<1399130415-5382-6-git-send-email-hch@lst.de>
	<20140505202149.GF12448@laptop.bfoster>
	<20140506080658.GA12085@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140506080658.GA12085@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@lst.de>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Tue, May 06, 2014 at 10:06:58AM +0200, Christoph Hellwig wrote:
> And remove a very confused comment.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_attr.c |   14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
> 
> [updated for a minor conflict in for-next]

Already seen that on a local merge - I fix conflicts like this
when I merge the topic branch into for-next. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
