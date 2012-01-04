Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q04GhwPn158215 for <xfs@oss.sgi.com>; Wed, 4 Jan 2012 10:43:59 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	oSL0jyzf2byMo4CN for <xfs@oss.sgi.com>;
	Wed, 04 Jan 2012 08:43:58 -0800 (PST)
Date: Wed, 4 Jan 2012 11:43:56 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Another SEEK_DATA/SEEK_HOLE  tester
Message-ID: <20120104164356.GA12924@infradead.org>
References: <4EFB1FEC.1050800@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4EFB1FEC.1050800@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Chris Mason <chris.mason@oracle.com>, xfs@oss.sgi.com

On Wed, Dec 28, 2011 at 09:55:56PM +0800, Jeff Liu wrote:
> A test tool to verify larger files with more extents(it can be used, but still need improvements).

Can you turn it into something that gets run automatically?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
