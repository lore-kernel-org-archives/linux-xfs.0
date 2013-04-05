Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7B0F229E28
	for <xfs@oss.sgi.com>; Fri,  5 Apr 2013 13:32:26 -0500 (CDT)
Date: Fri, 5 Apr 2013 13:32:25 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [v3 Repost] xfs: Add ratelimited printk for different alert levels
Message-ID: <20130405183225.GD22182@sgi.com>
References: <ca71153845539b0c76ba3e3aab9611ad6c5cf72b.1348641483.git.rprabhu@wnohang.net>
	<515339F7.8000505@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <515339F7.8000505@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: Raghavendra D Prabhu <rprabhu@wnohang.net>, elder@kernel.org, xfs@oss.sgi.com

On Wed, Mar 27, 2013 at 09:26:49AM -0500, Rich Johnston wrote:
> Ratelimited printk will be useful in printing xfs messages which are otherwise
> not required to be printed always due to their high rate (to prevent kernel ring
> buffer from overflowing), while at the same time required to be printed.
> 
> Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
> Reviewed-by: Rich Johnston <rjohnston@sgi.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Applied.

Thanks Raghavendra!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
