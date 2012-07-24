Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6ODMorf112235 for <xfs@oss.sgi.com>; Tue, 24 Jul 2012 08:22:51 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	vbeq5KgViNyeRQbl (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Jul 2012 06:22:47 -0700 (PDT)
Date: Tue, 24 Jul 2012 09:22:46 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3] xfs: re-enable xfsaild idle mode and fix associated
	races
Message-ID: <20120724132246.GA9142@infradead.org>
References: <1340880776-45730-1-git-send-email-bfoster@redhat.com>
	<20120702070502.GA25568@infradead.org>
	<20120702082952.GR19223@dastard> <4FF1A74C.1070003@redhat.com>
	<20120717065959.GA29748@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120717065959.GA29748@infradead.org>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Jul 17, 2012 at 03:00:00AM -0400, Christoph Hellwig wrote:
> Let's take the patch as-is for 3.6 as we have enough other work in that
> area queued.  We can clean it up later if needed.

Ben, any reason this never got picked up?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
