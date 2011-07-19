Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6JB1NRp167640 for <xfs@oss.sgi.com>; Tue, 19 Jul 2011 06:01:24 -0500
Received: from e34.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2165D7DA26
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2011 03:56:22 -0700 (PDT)
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152]) by
	cuda.sgi.com with ESMTP id MvUkJBTiK8EV0d9Y for
	<xfs@oss.sgi.com>; Tue, 19 Jul 2011 03:56:22 -0700 (PDT)
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com
	[9.17.195.228])
	by e34.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6J1NMZP029827
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2011 19:23:22 -0600
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p6J1aWEZ147818 for <xfs@oss.sgi.com>; Mon, 18 Jul 2011 19:36:32 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p6IJaVUB024086
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2011 13:36:31 -0600
Subject: Re: [PATCH 01/12] xfs: Remove the macro XFS_BUF_BFLAGS
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20110716015412.GB589@infradead.org>
References: <20110716012105.6629.24407.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<20110716012110.6629.52933.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<20110716015412.GB589@infradead.org>
Date: Mon, 18 Jul 2011 18:36:30 -0700
Message-ID: <1311039390.5505.10771.camel@chandra-lucid.beaverton.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
Cc: xfs@oss.sgi.com

Thanks for the review Christoph,

I will rebase to the latest git and resend the patches again with
appropriate changes and reviewed-by.

regards,

chandra
On Fri, 2011-07-15 at 21:54 -0400, Christoph Hellwig wrote:
> Looks fine,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
