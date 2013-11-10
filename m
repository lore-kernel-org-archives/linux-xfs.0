Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3DC1B7F81
	for <xfs@oss.sgi.com>; Sat,  9 Nov 2013 19:05:14 -0600 (CST)
Message-ID: <527EDBC7.6030307@sgi.com>
Date: Sat, 9 Nov 2013 19:05:11 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 00/37 V4] xfsprogs: CRC write support for xfs_db + more
References: <1383700043-32305-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1383700043-32305-1-git-send-email-david@fromorbit.com>
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

Hey Dave,

I am ready to pull in patches 1-16 of this series. Is that OK, or would 
you prefer to wait for all the patches?

The outstanding work I see is:
	[20/37] db: rewrite IO engine to use libxfs
  	[24/37] db: verify and calculate dquot CRCs
	[32/37] db: enable metadump on CRC filesystems
	Needs  a review

	[31/37] db: Unwind the IO stack on exit
	Reviewed, but needs a response to Christoph's question
	"Should be folded into patch 20?" (listed as unreviewed above).

	[36/37] repair: Increase default repair parallelism ...
	Waiting for another version from you.

Please let me know if I missed something.

Thanks
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
