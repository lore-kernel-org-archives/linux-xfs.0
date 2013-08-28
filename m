Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 937477F4E
	for <xfs@oss.sgi.com>; Wed, 28 Aug 2013 10:30:30 -0500 (CDT)
Message-ID: <521E1791.5090005@sgi.com>
Date: Wed, 28 Aug 2013 10:30:25 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstest: fix btrfs/006 for 10+ devices in SCRATCH_DEV_POOL
References: <1377263233-8903-1-git-send-email-sbehrens@giantdisaster.de>
	<1377263233-8903-4-git-send-email-sbehrens@giantdisaster.de>
In-Reply-To: <1377263233-8903-4-git-send-email-sbehrens@giantdisaster.de>
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
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org

Thanks for the patch Stefan, it has been committed.

--Rich

commit 0d3bbd18942bfac464d18f88c0a3c100c67a24f2
Author: Stefan Behrens <sbehrens@giantdisaster.de>
Date:   Fri Aug 23 13:07:13 2013 +0000

     xfstests: fix btrfs/006 for 10+ devices in SCRATCH_DEV_POOL

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
