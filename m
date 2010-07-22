Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6M6LGCc123088 for <xfs@oss.sgi.com>; Thu, 22 Jul 2010 01:21:16 -0500
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 968F0466A4F
	for <xfs@oss.sgi.com>; Wed, 21 Jul 2010 23:24:00 -0700 (PDT)
Received: from postoffice2.aconex.com (mail.aconex.com [203.89.202.182]) by
	cuda.sgi.com with ESMTP id vesywmxNOL0wcx0R for
	<xfs@oss.sgi.com>; Wed, 21 Jul 2010 23:24:00 -0700 (PDT)
Date: Thu, 22 Jul 2010 16:23:54 +1000 (EST)
From: Nathan Scott <nathans@aconex.com>
Message-ID: <1424814756.1148211279779834118.JavaMail.root@mail-au.aconex.com>
In-Reply-To: <20100722053057.GA1768@infradead.org>
Subject: Re: [PATCH] xfs_io: allow resvsp command for foreign filesystems
MIME-Version: 1.0
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


----- "Christoph Hellwig" <hch@infradead.org> wrote:

> Recent kernels implement the RESVP ioctl in common code, so using
> command for non-XFS filesystems is fine.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 

Looks good.

Reviewed-by: Nathan Scott <nathans@debian.org>


cheers.

-- 
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
