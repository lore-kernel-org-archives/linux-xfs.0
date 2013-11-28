Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 790BC7F37
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 15:19:06 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5AD068F8054
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 13:19:03 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Zhj0BC5KnBKiKLPn for <xfs@oss.sgi.com>;
	Thu, 28 Nov 2013 13:19:01 -0800 (PST)
Date: Fri, 29 Nov 2013 08:18:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ANNOUNCE] xfsprogs v3.2.0-alpha2
Message-ID: <20131128211858.GR10988@dastard>
References: <5293A699.20908@sgi.com>
 <20131128104002.GC26927@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131128104002.GC26927@infradead.org>
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
Cc: Rich Johnston <rjohnston@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Nov 28, 2013 at 02:40:02AM -0800, Christoph Hellwig wrote:
> On Mon, Nov 25, 2013 at 01:35:53PM -0600, Rich Johnston wrote:
> > Alpha version 3.2.0-alpha2 of xfsprogs has been released.
> 
> So what issues keep us issueing alpha release instead of making a proper
> .0 release?

There's still things to fix in xfs_repair before we do a full
release. Run xfs/291 recently?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
