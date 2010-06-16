Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5G9dPYn124400 for <xfs@oss.sgi.com>; Wed, 16 Jun 2010 04:39:26 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1FE9A14DF969
	for <xfs@oss.sgi.com>; Wed, 16 Jun 2010 02:42:03 -0700 (PDT)
Received: from bombadil.infradead.org ([18.85.46.34]) by cuda.sgi.com with
	ESMTP id lZcUfAdoVEcxpAdl for <xfs@oss.sgi.com>;
	Wed, 16 Jun 2010 02:42:03 -0700 (PDT)
Date: Wed, 16 Jun 2010 05:42:00 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS status update for May 2010
Message-ID: <20100616094200.GB16216@infradead.org>
References: <20100615132221.GA17385@infradead.org>
	<cone.1276679587.153934.32947.1001@bork.lsof.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <cone.1276679587.153934.32947.1001@bork.lsof.org>
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
To: Roel van Meer <rolek@bokxing.nl>
Cc: xfs@oss.sgi.com

On Wed, Jun 16, 2010 at 11:13:07AM +0200, Roel van Meer wrote:
> As of today I'm running 2.6.35-rc3 with XFS and delayed logging on a 4GB
> software raid0 we use to do nightly builds of about 150 software
> packages (kernel, samba, etc) on Slackware 10.1.
> 
> If there's anything specific I can do, please let me know. I have
> some more hardware around to test with.

As long as things just work everything is perfect!  If you have any
performance numbers that compare to older kernel / the non delayed
logging case for your workload we would certainly be interested in them.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
