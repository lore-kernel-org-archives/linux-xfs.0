Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B985B7F47
	for <xfs@oss.sgi.com>; Mon, 12 Oct 2015 23:30:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 56EE8AC004
	for <xfs@oss.sgi.com>; Mon, 12 Oct 2015 21:30:21 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	SWnhrHfKtvGkA32N for <xfs@oss.sgi.com>;
	Mon, 12 Oct 2015 21:30:18 -0700 (PDT)
Date: Tue, 13 Oct 2015 15:30:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: mkfs.xfs -n size=65536
Message-ID: <20151013043016.GE31326@dastard>
References: <0F279340237AA148AD7E3C6A70561A5E01266BE7@xmb-rcd-x14.cisco.com>
	<20151013002308.GI27164@dastard>
	<8a1b26a3b869448e805485c529c447a4@XCH-ALN-020.cisco.com>
	<20151013033304.GL27164@dastard>
	<c88efb6bc4ad49779e965a7a67b2df57@XCH-ALN-020.cisco.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <c88efb6bc4ad49779e965a7a67b2df57@XCH-ALN-020.cisco.com>
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
To: "Al Lau (alau2)" <alau2@cisco.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Oct 13, 2015 at 03:55:26AM +0000, Al Lau (alau2) wrote:
> To remedy the fragmented files in our production systems, can I
> run the xfs_fsr utility to de-fragment the files?

Well, first you need to determine that the files are fragmented
and that it is affecting performance....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
