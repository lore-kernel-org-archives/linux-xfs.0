Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3A0E329E11
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 10:26:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2852E30405F
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 08:26:08 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id zvAODI1ByfTbJIfY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 26 Jul 2013 08:26:07 -0700 (PDT)
Date: Fri, 26 Jul 2013 11:25:59 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: Re: [PATCH v6 1/7] xfs: create wrappers for converting kuid_t
	to/from uid_t
Message-ID: <20130726112559.459d3ed0@oracle.com>
In-Reply-To: <20130726004211.GB21982@dastard>
References: <20130725114921.0d860cc4@oracle.com>
	<20130726004211.GB21982@dastard>
Mime-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, 26 Jul 2013 10:42:11 +1000
Dave Chinner <david@fromorbit.com> wrote:

> On Thu, Jul 25, 2013 at 11:49:21AM -0400, Dwight Engen wrote:
> > Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
> 
> Dwight, can you add the reviewed-by tags people have sent to the
> commit messages?

Sure can, sorry I didn't realize I was supposed to carry those but it
makes total sense.

> When you repost a patch series, that's a reminder to everyone who
> has already looked at this code. It's also a reminder to the
> reviewers of where in the patch set they need to concentrate new
> reviews...
> 
> Cheers,
> 
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
