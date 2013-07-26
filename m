Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4CC527F37
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 19:42:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D525CAC002
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 17:42:15 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	YbzzArr8aG4w0L5l for <xfs@oss.sgi.com>;
	Thu, 25 Jul 2013 17:42:14 -0700 (PDT)
Date: Fri, 26 Jul 2013 10:42:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v6 1/7] xfs: create wrappers for converting kuid_t
	to/from uid_t
Message-ID: <20130726004211.GB21982@dastard>
References: <20130725114921.0d860cc4@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130725114921.0d860cc4@oracle.com>
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
To: Dwight Engen <dwight.engen@oracle.com>
Cc: xfs@oss.sgi.com

On Thu, Jul 25, 2013 at 11:49:21AM -0400, Dwight Engen wrote:
> Signed-off-by: Dwight Engen <dwight.engen@oracle.com>

Dwight, can you add the reviewed-by tags people have sent to the
commit messages?

When you repost a patch series, that's a reminder to everyone who
has already looked at this code. It's also a reminder to the
reviewers of where in the patch set they need to concentrate new
reviews...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
