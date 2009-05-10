Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4AI3NTe195566 for <xfs@oss.sgi.com>; Sun, 10 May 2009 13:03:24 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 03F4B1D219DD
	for <xfs@oss.sgi.com>; Sun, 10 May 2009 11:03:28 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id D2r14fewlS1GiYNV for
	<xfs@oss.sgi.com>; Sun, 10 May 2009 11:03:28 -0700 (PDT)
Date: Sun, 10 May 2009 14:03:28 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_repair: open filesystem device exclusively
Message-ID: <20090510180328.GA3321@infradead.org>
References: <49B48B8E.3030602@houseofnate.net>
	<49B491EA.4090003@houseofnate.net>
	<20090316212332.GA8496@infradead.org>
	<4A024B7C.4010409@houseofnate.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A024B7C.4010409@houseofnate.net>
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
To: "Nathaniel W. Turner" <nate@houseofnate.net>
Cc: xfs@oss.sgi.com

On Wed, May 06, 2009 at 10:46:20PM -0400, Nathaniel W. Turner wrote:
> ...just a friendly reminder to look at this again now that 3.0.1 is out.


Thanks for the heads-up.  I've put the patch in.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
