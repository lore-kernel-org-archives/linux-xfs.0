Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AFC9D7F37
	for <xfs@oss.sgi.com>; Sun, 12 May 2013 19:03:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7F8F5304039
	for <xfs@oss.sgi.com>; Sun, 12 May 2013 17:03:31 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ehKKHE8LyyOPapXB for <xfs@oss.sgi.com>;
	Sun, 12 May 2013 17:03:26 -0700 (PDT)
Date: Mon, 13 May 2013 10:03:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3] xfstests: remove fio config files after finished test
Message-ID: <20130513000321.GF32675@dastard>
References: <1368346884-31264-1-git-send-email-wenqing.lz@taobao.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1368346884-31264-1-git-send-email-wenqing.lz@taobao.com>
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
Cc: Zheng Liu <wenqing.lz@taobao.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Sun, May 12, 2013 at 04:21:24PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> After finished test, temporarily fio config file should be removed.
> This commit tries to fix this problem in the following test cases:
>   - generic/299-300
>   - ext4/301-304
>   - shared/305
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> Cc: Eric Sandeen <sandeen@sandeen.net>
> Cc: Dave Chinner <david@fromorbit.com>

Looks ok from a quick glance.

Acked-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
