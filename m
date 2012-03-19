Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2JMVEgB168247 for <xfs@oss.sgi.com>; Mon, 19 Mar 2012 17:31:14 -0500
Date: Mon, 19 Mar 2012 18:31:11 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 1/1] xfsdump: update summaries in preparation for release
Message-ID: <20120319223111.GA28162@infradead.org>
References: <20120319204256.762648511@sgi.com>
	<20120319204350.149959363@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120319204350.149959363@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: bpm@sgi.com
Cc: Christoph Hellwig <hch@infradead.org>, Nathan Scott <nathans@debian.org>, xfs@oss.sgi.com

Looks good, but I'd bump the version to 3.1.1, mostly due to the
multistream support that requires pthreads now.


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
