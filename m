Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6VBa4PG147824 for <xfs@oss.sgi.com>; Fri, 31 Jul 2009 06:36:06 -0500
Date: Fri, 31 Jul 2009 07:36:52 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS inconsistent lock state (-rc4)
Message-ID: <20090731113652.GA31758@infradead.org>
References: <1249039546.29587.72.camel@johannes.local>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1249039546.29587.72.camel@johannes.local>
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
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-masters <xfs-masters@oss.sgi.com>, xfs@oss.sgi.com

On Fri, Jul 31, 2009 at 01:25:46PM +0200, Johannes Berg wrote:
> After pushing a lot of data onto the disk, including creating millions
> of hardlinks (rsync backup run with --link-dest):

I've posted a fix for this to the list a while ago, still hoping that
Felix will push it for 2.6.31.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
