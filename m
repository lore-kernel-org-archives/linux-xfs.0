Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o35BVAZK243889 for <xfs@oss.sgi.com>; Mon, 5 Apr 2010 06:31:10 -0500
Date: Mon, 5 Apr 2010 07:32:59 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 7/7] xfs: xfs_log_recover.c odds and ends
Message-ID: <20100405113259.GB6338@infradead.org>
References: <201003182254.o2IMsGKO001893@stout.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201003182254.o2IMsGKO001893@stout.americas.sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Mar 18, 2010 at 05:54:16PM -0500, Alex Elder wrote:
> Odds and ends in "xfs_log_recover.c".  This patch just contains a
> bunch of minor things that didn't seem to warrant their own
> individual patches.

This is changing too many different things without much explanation.
I think it needs to be split and documented much better.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
