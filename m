Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9RMP0OX123397 for <xfs@oss.sgi.com>; Thu, 27 Oct 2011 17:25:02 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A6FE21CC3F75
	for <xfs@oss.sgi.com>; Thu, 27 Oct 2011 15:24:59 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	zaQsmUqFeCwQCisM for <xfs@oss.sgi.com>;
	Thu, 27 Oct 2011 15:24:59 -0700 (PDT)
Date: Thu, 27 Oct 2011 18:24:57 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 1/4] Define a new function xfs_this_quota_on()
Message-ID: <20111027222457.GA24260@infradead.org>
References: <20111027220523.2638.12351.sendpatchset@chandra-lucid.austin.ibm.com>
	<20111027220529.2638.41757.sendpatchset@chandra-lucid.austin.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111027220529.2638.41757.sendpatchset@chandra-lucid.austin.ibm.com>
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

On Thu, Oct 27, 2011 at 05:05:29PM -0500, Chandra Seetharaman wrote:
> Create a new function xfs_this_quota_on() that takes a xfs_mount
> data srtucture and a disk quota type and returns true if the specified
> type of quota is ON in the xfs_mount data structure.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
