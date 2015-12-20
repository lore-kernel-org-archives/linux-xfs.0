Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 36F077F4E
	for <xfs@oss.sgi.com>; Sun, 20 Dec 2015 14:47:02 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 22F268F8033
	for <xfs@oss.sgi.com>; Sun, 20 Dec 2015 12:47:02 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	lbPVFw8EQB96srQU for <xfs@oss.sgi.com>;
	Sun, 20 Dec 2015 12:46:59 -0800 (PST)
Date: Mon, 21 Dec 2015 07:46:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFCv4 00/22] xfs-documentation: massive cleanups and add v5
	format, reverse-mapping, reflink, and dedupe support
Message-ID: <20151220204657.GT26718@dastard>
References: <20151219091208.15558.65013.stgit@birch.djwong.org>
	<20151220152936.GA20135@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151220152936.GA20135@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, "Darrick J. Wong" <darrick.wong@oracle.com>

On Sun, Dec 20, 2015 at 07:29:36AM -0800, Christoph Hellwig wrote:
> On Sat, Dec 19, 2015 at 01:12:08AM -0800, Darrick J. Wong wrote:
> > This patch set does the following:
> 
> I'll review the actual patches once I'll get more time, but maybe it's a
> good idea to split this series and get all the cleanups and fixes in
> ASAP and only land the new reverse mapping and reflink bits once the
> code hits mainline?

I'll be cherrying picking all the cleanups and fixes out of all the
various patch series over the next couple days, so that's in effect
what will happen...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
