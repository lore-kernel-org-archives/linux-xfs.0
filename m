Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9NCO4D6044603 for <xfs@oss.sgi.com>; Tue, 23 Oct 2012 07:24:04 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	QMWRnn4kxysrG0Qg (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 23 Oct 2012 05:25:47 -0700 (PDT)
Date: Tue, 23 Oct 2012 08:25:46 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] respect DESTDIR when installing
Message-ID: <20121023122546.GD7341@infradead.org>
References: <1348529978-30048-1-git-send-email-vapier@gentoo.org>
	<1348529978-30048-2-git-send-email-vapier@gentoo.org>
	<20120925094139.GK9189@infradead.org>
	<201210190021.59105.vapier@gentoo.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201210190021.59105.vapier@gentoo.org>
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
To: Mike Frysinger <vapier@gentoo.org>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Oct 19, 2012 at 12:21:58AM -0400, Mike Frysinger wrote:
> On Tuesday 25 September 2012 05:41:39 Christoph Hellwig wrote:
> > Looks good.  I guess this is for xfstests as it should be working for
> > the real tools?
> 
> hmm, these don't appear to have been merged.  is there something i should do ?

No, but I stopped applying patches to the kernel.org repos, with the SGI
people pickingup the slack using the oss.sgi.com repos.

Ben, any chance you could re-review the series and apply it?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
