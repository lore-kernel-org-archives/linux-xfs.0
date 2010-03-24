Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2OG7K1n006081 for <xfs@oss.sgi.com>; Wed, 24 Mar 2010 11:07:20 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 50CBF145E8BB
	for <xfs@oss.sgi.com>; Wed, 24 Mar 2010 09:09:01 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 0ei5o8VyEdzzbOwG for
	<xfs@oss.sgi.com>; Wed, 24 Mar 2010 09:09:01 -0700 (PDT)
Message-ID: <4BAA3916.5060604@sandeen.net>
Date: Wed, 24 Mar 2010 11:08:54 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: filter 203 mount point
References: <4BA98694.2070506@sandeen.net>
	<20100324154520.GA9168@infradead.org>
In-Reply-To: <20100324154520.GA9168@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On 03/24/2010 10:45 AM, Christoph Hellwig wrote:
> On Tue, Mar 23, 2010 at 10:27:16PM -0500, Eric Sandeen wrote:
>> Right now this only works if TEST_DIR == /mnt/test
> 
> Looks good,
> 
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> btw, this was missing a signoff.
> 

yep was too late last night ;)  will add it.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
