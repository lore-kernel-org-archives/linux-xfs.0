Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n25LTom8167813 for <xfs@oss.sgi.com>; Thu, 5 Mar 2009 15:29:50 -0600
Date: Thu, 5 Mar 2009 16:29:20 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3 v2] xfs: include header files for prototypes
Message-ID: <20090305212920.GA1883@infradead.org>
References: <20090304183136.525.13769.stgit@f10box.hanneseder.net>
	<20090304183418.525.22262.stgit@f10box.hanneseder.net>
	<20090305133917.GC14854@lst.de>
	<20090305141912.22775.64010.stgit@f10box.hanneseder.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090305141912.22775.64010.stgit@f10box.hanneseder.net>
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
To: Hannes Eder <hannes@hanneseder.net>
Cc: kernel-janitors@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org

On Thu, Mar 05, 2009 at 03:20:25PM +0100, Hannes Eder wrote:
> I still treat this as a Acked-by: ... Ok?

Should be a review, as far as you can review these sort of patches..

> hm. but that way it is still included before xfs_mount.h.

Sure, but the point is entirely the comment which describes the block
of includes below.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
