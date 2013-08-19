Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C29D87F7C
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 10:02:37 -0500 (CDT)
Message-ID: <521233B8.9090101@sgi.com>
Date: Mon, 19 Aug 2013 10:03:20 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/3] xfstests 313: user namespace uid/gids in an inode
References: <20130625153443.08142635@oracle.com>
	<20130626010931.GA29376@dastard>
	<20130627120334.0c4de386@oracle.com>
In-Reply-To: <20130627120334.0c4de386@oracle.com>
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
To: Dwight Engen <dwight.engen@oracle.com>
Cc: xfs@oss.sgi.com

Thanks for splitting the original patch Dwight, this patch has been 
committed.

--Rich

commit 531a2473ce411fdc0af07d7ef86b2aaadf239b39
Author: Dwight Engen <dwight.engen@oracle.com>
Date:   Thu Jun 27 16:03:34 2013 +0000

     xfstests generic/317: user namespace uid/gids in an inode

     [rjohnston: renumbered test to 317]

     Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
     Reviewed-by: <rjohnston@sgi.com>
     Signed-off-by: <rjohnston@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
