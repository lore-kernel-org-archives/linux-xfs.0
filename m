Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A45037F50
	for <xfs@oss.sgi.com>; Sun, 20 Oct 2013 23:03:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 32B41AC001
	for <xfs@oss.sgi.com>; Sun, 20 Oct 2013 21:03:26 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	d0tvyUKQuOfGsIbr for <xfs@oss.sgi.com>;
	Sun, 20 Oct 2013 21:03:23 -0700 (PDT)
Date: Mon, 21 Oct 2013 15:03:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH -next] xfs: remove duplicated include from xfs_bmap.c
Message-ID: <20131021040317.GD4446@dastard>
References: <CAPgLHd-Pe_oBza-esdghKzFq5T2-Pj26YSBuEggAC9qR7vAdeg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPgLHd-Pe_oBza-esdghKzFq5T2-Pj26YSBuEggAC9qR7vAdeg@mail.gmail.com>
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
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: bpm@sgi.com, elder@kernel.org, yongjun_wei@trendmicro.com.cn, xfs@oss.sgi.com, linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 10:56:15AM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Remove duplicated include.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

That's fixed in a series of patches that has already been posted for
review. See:

http://oss.sgi.com/archives/xfs/2013-10/msg00374.html

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
