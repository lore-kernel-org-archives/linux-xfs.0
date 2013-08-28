Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0BD707F37
	for <xfs@oss.sgi.com>; Wed, 28 Aug 2013 10:18:58 -0500 (CDT)
Message-ID: <521E14DD.1060808@sgi.com>
Date: Wed, 28 Aug 2013 10:18:53 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH V4] xfstests: don't remove the two first devices from
	SCRATCH_DEV_POOL
References: <1377263233-8903-1-git-send-email-sbehrens@giantdisaster.de>
In-Reply-To: <1377263233-8903-1-git-send-email-sbehrens@giantdisaster.de>
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

commit f1dce456c594a784afb723d1bc7c09056ab3d9d9
Author: Stefan Behrens <sbehrens@giantdisaster.de>
Date:   Fri Aug 23 13:07:10 2013 +0000

     xfstests: don't remove the two first devices from SCRATCH_DEV_POOL

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
