Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8DMQvms094631 for <xfs@oss.sgi.com>; Tue, 13 Sep 2011 17:26:57 -0500
Date: Tue, 13 Sep 2011 18:26:49 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [xfs-masters] xfs deadlock in stable kernel 3.0.4
Message-ID: <20110913222649.GB26677@infradead.org>
References: <1D2B34A7-7BB9-4E4E-9CA2-382C210E125F@profihost.ag>
	<20110912152133.GA8345@infradead.org>
	<C6515E45-5724-43DD-95A8-1F89AFE29601@profihost.ag>
	<20110912200543.GA22409@infradead.org>
	<4E6EF274.7050007@profihost.ag>
	<20110913205018.GA8543@infradead.org>
	<1315950742.2159.89.camel@doink> <1315951093.2159.92.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1315951093.2159.92.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Stefan Priebe - Profihost AG <s.priebe@profihost.ag>

On Tue, Sep 13, 2011 at 04:58:13PM -0500, Alex Elder wrote:
> > Reviewed-by: Alex Elder <aelder@sgi.com>
> 
> Nevermind--the latest code doesn't look quite
> like that and doesn't suffer the same problem.

It needs to go into 3.1, where this bug was introduced.  In the
3.2 queue it already has been fixed by different means

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
