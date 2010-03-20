Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2KGYGT2061251 for <xfs@oss.sgi.com>; Sat, 20 Mar 2010 11:34:22 -0500
Date: Sat, 20 Mar 2010 12:35:54 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/7] xfs: add const qualifiers to xfs error function args
Message-ID: <20100320163554.GA31444@infradead.org>
References: <201003182253.o2IMrkx6001843@stout.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201003182253.o2IMrkx6001843@stout.americas.sgi.com>
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

On Thu, Mar 18, 2010 at 05:53:46PM -0500, Alex Elder wrote:
> Change the tag and file name arguments to xfs_error_report() and
> xfs_corruption_error() to use a const qualifier.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
