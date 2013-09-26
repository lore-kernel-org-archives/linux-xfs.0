Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3FFCA7F3F
	for <linux-xfs@oss.sgi.com>; Thu, 26 Sep 2013 17:48:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2DF1230405F
	for <linux-xfs@oss.sgi.com>; Thu, 26 Sep 2013 15:48:45 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	PgUdIXfJzk8RYHUk for <linux-xfs@oss.sgi.com>;
	Thu, 26 Sep 2013 15:48:40 -0700 (PDT)
Date: Fri, 27 Sep 2013 08:48:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: add xfs/291 to auto group
Message-ID: <20130926224836.GT26872@dastard>
References: <52444130.6030000@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52444130.6030000@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>

On Thu, Sep 26, 2013 at 09:14:08AM -0500, Eric Sandeen wrote:
> 291 passes just fine w/ current xfsprogs on non-crc filesystems,
> so add it to the auto group.

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
