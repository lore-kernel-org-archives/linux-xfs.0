Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7B0787F37
	for <xfs@oss.sgi.com>; Sun, 12 May 2013 19:06:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4B6578F8033
	for <xfs@oss.sgi.com>; Sun, 12 May 2013 17:06:34 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	e9KLHBGrJDdQd4Ol for <xfs@oss.sgi.com>;
	Sun, 12 May 2013 17:06:33 -0700 (PDT)
Date: Mon, 13 May 2013 10:05:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: change file mode
Message-ID: <20130513000531.GG32675@dastard>
References: <1368347826-32152-1-git-send-email-wenqing.lz@taobao.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1368347826-32152-1-git-send-email-wenqing.lz@taobao.com>
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
To: Zheng Liu <gnehzuil.liu@gmail.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, xfs@oss.sgi.com

On Sun, May 12, 2013 at 04:37:06PM +0800, Zheng Liu wrote:
> Now in tests/ there are some test cases whose mode is 0644.  But they
> should be 0755.  So fix it.
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> Cc: Dave Chinner <david@fromorbit.com>

Looks good. Thanks for following up on this.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
