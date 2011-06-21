Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5L2mYTC212380 for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 21:48:35 -0500
Received: from e4.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 66BB6134B705
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 19:48:33 -0700 (PDT)
Received: from e4.ny.us.ibm.com (e4.ny.us.ibm.com [32.97.182.144]) by
	cuda.sgi.com with ESMTP id hQYmxwRTIbC38fMj for
	<xfs@oss.sgi.com>; Mon, 20 Jun 2011 19:48:33 -0700 (PDT)
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by e4.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5L2QsFU010614
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 22:26:54 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p5L2mWI6139086 for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 22:48:32 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p5L2mWEA014275 for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 23:48:32 -0300
Message-ID: <4E00067A.6040004@linux.vnet.ibm.com>
Date: Mon, 20 Jun 2011 19:48:26 -0700
From: Allison Henderson <achender@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: update test 042 golden output
References: <20110620104811.GA1925@infradead.org>
In-Reply-To: <20110620104811.GA1925@infradead.org>
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
Cc: xfs@oss.sgi.com

On 06/20/2011 03:48 AM, Christoph Hellwig wrote:
> Add the golden output for the newly added tests in common.punch.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>
>
Thanks Christoph, sorry for the breakage.  I have another patch that 
corrects a bug in the fiemap filter that 242 and 252 use.  I will modify 
that patch to apply on top of this one.  Thanks again!

Allison Henderson

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
