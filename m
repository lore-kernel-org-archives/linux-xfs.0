Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E676A7F6D
	for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 07:26:41 -0600 (CST)
Message-ID: <52DFC70D.1010206@sgi.com>
Date: Wed, 22 Jan 2014 07:26:37 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/7] xfstests: various fixes and additions for XFS
References: <1390198957-17184-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1390198957-17184-1-git-send-email-david@fromorbit.com>
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

On 01/20/2014 12:22 AM, Dave Chinner wrote:
> Hi folks,
>
> The following series cleans up some of the infrastructure for
> handling XFS filesystems, and fixes a few failures that have
> resulted from recent changes to mkfs defaults. There is also a new
> log recovery test that uses fsstress to generate load and log
> traffic. This was causing failures and hangs on recent kernels.
>
> Cheers,
>
> Dave.
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

This series has been committed.

Thanks
--Rich


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
