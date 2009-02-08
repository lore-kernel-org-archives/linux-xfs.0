Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n180bd4R140062 for <xfs@oss.sgi.com>; Sat, 7 Feb 2009 18:37:40 -0600
In-Reply-To: <20090126073203.169959000@bombadil.infradead.org>
References: <20090126073136.384490000@bombadil.infradead.org>
	<20090126073203.169959000@bombadil.infradead.org>
Mime-Version: 1.0 (Apple Message framework v753.1)
Message-Id: <F63EF174-B636-470A-B204-878C98936552@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
Subject: Re: [PATCH 14/17] xfs: remove the unused XFS_QMOPT_DQLOCK flag
Date: Sat, 7 Feb 2009 18:35:57 -0600
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com


On Jan 26, 2009, at 1:31 AM, Christoph Hellwig wrote:

> The XFS_QMOPT_DQLOCK flag introduces major complexity in the quota  
> subsystem
> but isn't actually used anywhere.  So remove it and all the hazzles it
> introduces.
>
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Felix Blyakher <felixb@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
