Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1AE3F7F9D
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 15:49:07 -0500 (CDT)
Message-ID: <521284BE.2020808@sgi.com>
Date: Mon, 19 Aug 2013 15:49:02 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfstests generic/318: user namespace uid/gids in an ACL
References: <20130625153443.08142635@oracle.com>
	<20130626010931.GA29376@dastard>
	<20130627120340.20e494ad@oracle.com> <5212277D.2070307@sgi.com>
	<20130819133442.3200b70e@oracle.com>
In-Reply-To: <20130819133442.3200b70e@oracle.com>
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

Looks good Dwight, thanks for reworking the patch, it has been committed.

commit 511f9be2595f4d9bc4447335d839227d85969e8a
Author: Dwight Engen <dwight.engen@oracle.com>
Date:   Mon Aug 19 17:34:42 2013 +0000

     xfstests generic/318: user namespace uid/gids in an ACL

     Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
     Reviewed-by: Rich Johnston <rjohnston@sgi.com>
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
