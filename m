Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 910147F51
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 17:25:42 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2283EAC003
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 15:25:42 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	QNdNr5t5vLLsvyxf for <xfs@oss.sgi.com>;
	Tue, 03 Dec 2013 15:25:40 -0800 (PST)
Date: Wed, 4 Dec 2013 10:24:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstest generic/280: wait for setquota to finish before
	umount
Message-ID: <20131203232423.GB10988@dastard>
References: <1382637381-4847-1-git-send-email-guangyu.sun@oracle.com>
	<529DF220.9060208@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <529DF220.9060208@sgi.com>
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
Cc: Guangyu Sun <guangyu.sun@oracle.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Dec 03, 2013 at 09:00:48AM -0600, Rich Johnston wrote:
> This has been committed.
> 
> Thanks
> --Rich
> 
> commit 527eeb43e5c7cfd642d81bc3c12e746d2a3733ff
> Author: Guangyu Sun <guangyu.sun@oracle.com>
> Date:   Thu Oct 24 17:56:21 2013 +0000
> 
>     xfstest generic/280: wait for setquota to finish before umount

Rich, I know you read the email I sent about trying to
introduce some conventions for patch subject lines for xfstests
commits.  Cleanliness in the commit history is important, and it's
something that we need to focus on to ensure we all commit patches
using the same conventions.

Hence if you are going to commit patches independently, can you can
you please rewrite the commit messages to follow the conventions I
outlined?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
