Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBGABcZJ033589 for <xfs@oss.sgi.com>; Thu, 16 Dec 2010 04:11:39 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 146BB1F7D15
	for <xfs@oss.sgi.com>; Thu, 16 Dec 2010 02:13:32 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id BFLEOOjNidPHVgeS for
	<xfs@oss.sgi.com>; Thu, 16 Dec 2010 02:13:32 -0800 (PST)
Date: Thu, 16 Dec 2010 05:13:31 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v4] xfstests: pwrite hang when writing from mmaped buffer
	of the same page
Message-ID: <20101216101331.GA20505@infradead.org>
References: <1292466652-15563-1-git-send-email-xin.zhong@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1292466652-15563-1-git-send-email-xin.zhong@intel.com>
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
To: "Zhong, Xin" <xin.zhong@intel.com>
Cc: xfs@oss.sgi.com

On Thu, Dec 16, 2010 at 10:30:52AM +0800, Zhong, Xin wrote:
> The problem is found in meego testing on btrfs:
> http://bugs.meego.com/show_bug.cgi?id=6672

As I didn't get around commiting v3 yesterday i've now put in this
updated version.

Thanks a lot again!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
