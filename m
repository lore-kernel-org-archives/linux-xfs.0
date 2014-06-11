Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 049347F3F
	for <xfs@oss.sgi.com>; Wed, 11 Jun 2014 18:15:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E66A48F8040
	for <xfs@oss.sgi.com>; Wed, 11 Jun 2014 16:15:36 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	TO1JvSMgooyntNJr for <xfs@oss.sgi.com>;
	Wed, 11 Jun 2014 16:15:31 -0700 (PDT)
Date: Thu, 12 Jun 2014 09:15:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfsprogs: add mount options to xfs.5 manpage
Message-ID: <20140611231509.GM9508@dastard>
References: <5398B5ED.6030703@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5398B5ED.6030703@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Karel Zak <kzak@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Jun 11, 2014 at 03:02:53PM -0500, Eric Sandeen wrote:
> This is a straight cut and paste from the util-linux
> mount manpage to xfs.5.

Which is pretty much a straight cut and paste from the kernel
Documentation/filesystems/xfs.txt file....

> 
> It's pretty much impossible for util-linux to keep up
> with every filesystem out there, and Karel has more than
> once expressed a wish that mount options move into fs-specific
> manpages.

As have I. ;)

> So, here we go.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

A quick read of the source looks fine. I'll apply it and review
the produced output later today....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
