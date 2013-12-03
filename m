Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 472067F51
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 17:30:26 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E19F6AC002
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 15:30:25 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	n72NFYrUSc45HKzA for <xfs@oss.sgi.com>;
	Tue, 03 Dec 2013 15:30:24 -0800 (PST)
Date: Wed, 4 Dec 2013 10:30:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: stop special casing nfs and udf
Message-ID: <20131203233017.GC10988@dastard>
References: <20131107204635.GA22954@infradead.org>
	<20131122091553.GA32568@infradead.org>
	<20131202174045.GA21861@infradead.org>
	<20131202232549.GV8803@dastard> <20131202233629.GM1935@sgi.com>
	<20131203042936.GY8803@dastard> <529DDE2D.3000501@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <529DDE2D.3000501@sgi.com>
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
Cc: xfs@oss.sgi.com

On Tue, Dec 03, 2013 at 07:35:41AM -0600, Rich Johnston wrote:
> On 12/02/2013 10:29 PM, Dave Chinner wrote:
> >On Mon, Dec 02, 2013 at 05:36:30PM -0600, Ben Myers wrote:
> >Hence if a developer sends a ping to remind the maintainers about a
> >reviewed patch that has been sitting around, then I'm going to do
> >something about it straight away...
> My apologies to Christoph. I missed that I thought he was waiting
> for a review, not a commit from me.

One of the roles of a maintainer is to review code when nobody
else steps up to do it. So rather than wait for someone else to
review the code, you should do it yourself, wait 24-48 for any
responses once you give it a Reviewed-by tag, and then you can
commit it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
