Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7EEKYVW109613 for <xfs@oss.sgi.com>; Fri, 14 Aug 2009 09:20:50 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2E1CB1B6E4B3
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2009 07:21:21 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id INHRrOMZj7DNWoCs for
	<xfs@oss.sgi.com>; Fri, 14 Aug 2009 07:21:21 -0700 (PDT)
Date: Fri, 14 Aug 2009 10:18:07 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Patch] Re: xfs crash, kernel 2.6.29
Message-ID: <20090814141807.GA2891@infradead.org>
References: <200908110921.50752.Christian.Fischer@easterngraphics.com>
	<20090811142029.GB30913@infradead.org>
	<200908141456.58683.Christian.Fischer@easterngraphics.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200908141456.58683.Christian.Fischer@easterngraphics.com>
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
To: Christian Fischer <Christian.Fischer@easterngraphics.com>
Cc: Christoph Hellwig <hch@infradead.org>, Andrew Lyon <andrew.lyon@gmail.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Fri, Aug 14, 2009 at 02:56:58PM +0200, Christian Fischer wrote:
> backported to 2.6.29-xen-r4 from
> http://code.google.com/p/gentoo-xen-kernel/downloads/list
> 
> Can you please review it?

I'll reviewed it and do some QA over the weekend, and we'll send it to
-stable then.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
