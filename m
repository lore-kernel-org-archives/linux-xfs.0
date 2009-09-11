Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8BIx06l040585 for <xfs@oss.sgi.com>; Fri, 11 Sep 2009 13:59:01 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9D270B2EEDE
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2009 12:00:12 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id HMIFZm8YICq0k8em for
	<xfs@oss.sgi.com>; Fri, 11 Sep 2009 12:00:12 -0700 (PDT)
Message-ID: <4AAA9E3B.8000904@sandeen.net>
Date: Fri, 11 Sep 2009 14:00:11 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] libdisk: use major/minor when calling dmsetup
References: <4AAA89F4.8060708@sandeen.net>
	<20090911185130.GA11671@infradead.org>
In-Reply-To: <20090911185130.GA11671@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> Looks good to me.  A library API to device mapper would be even better..


But IIRC agk said that will never happen ;)

mkp's stuff will be even better when it's ready...

-Eric

> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
