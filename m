Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBV3agIZ027527 for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 21:36:44 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6B9B31799B91
	for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 19:36:40 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id BHMWXhPud0zSiAke for
	<xfs@oss.sgi.com>; Tue, 30 Dec 2008 19:36:40 -0800 (PST)
Message-ID: <495AE8A0.8040508@sandeen.net>
Date: Tue, 30 Dec 2008 21:36:00 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 4/5] xfstests: test 196, add a testcase for renames across
	project boundaries
References: <20081230230810.986105000@bombadil.infradead.org>
	<20081230230913.450971000@bombadil.infradead.org>
In-Reply-To: <20081230230913.450971000@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:

> Make sure rename across project boundaries is rejected and doesn't
> cause hangs.  Based on a report and testcase from Arkadiusz Miskiewicz.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks fine to me.

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
