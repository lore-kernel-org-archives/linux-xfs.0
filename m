Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7VC2b8h206255 for <xfs@oss.sgi.com>; Wed, 31 Aug 2011 07:02:39 -0500
Date: Wed, 31 Aug 2011 08:02:29 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsdump: remove unnecessary #ifdefs
Message-ID: <20110831120229.GA16351@infradead.org>
References: <1314740824-4231-1-git-send-email-wkendall@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1314740824-4231-1-git-send-email-wkendall@sgi.com>
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
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs@oss.sgi.com

Looks good to me, I always hated the ifdef madness in xfsdump.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
