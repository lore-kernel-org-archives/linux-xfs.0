Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6OBeslW206217 for <xfs@oss.sgi.com>; Sun, 24 Jul 2011 06:40:54 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 81E03135861E
	for <xfs@oss.sgi.com>; Sun, 24 Jul 2011 04:40:53 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	wiG39Lx3gtkCKw7l for <xfs@oss.sgi.com>;
	Sun, 24 Jul 2011 04:40:53 -0700 (PDT)
Date: Sun, 24 Jul 2011 07:40:52 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/12 v3] xfs: Remove the macro XFS_BUF_ERROR and family
Message-ID: <20110724114052.GE26332@infradead.org>
References: <20110722233933.14612.65879.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<20110722233951.14612.3794.sendpatchset@chandra-lucid.beaverton.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110722233951.14612.3794.sendpatchset@chandra-lucid.beaverton.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Fri, Jul 22, 2011 at 04:39:51PM -0700, Chandra Seetharaman wrote:
> Remove the definitions and usage of the macros XFS_BUF_ERROR,
> XFS_BUF_GETERROR and XFS_BUF_ISERROR.

Looks good to me,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
