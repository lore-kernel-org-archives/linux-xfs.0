Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4066E7F3F
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 11:51:09 -0500 (CDT)
Message-ID: <526166F9.9020209@sgi.com>
Date: Fri, 18 Oct 2013 11:51:05 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] xfs: don't assert fail on bad inode numbers
References: <1378208858-20557-1-git-send-email-david@fromorbit.com>
	<1378208858-20557-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1378208858-20557-3-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

This has been committed.

Thanks
--Rich

commit ea6a00d47a01bc1df218742784712a12929ab77e
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Sep 30 03:15:18 2013 +0000

     xfs: don't assert fail on bad inode numbers

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
