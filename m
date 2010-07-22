Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6M5JWDL120226 for <xfs@oss.sgi.com>; Thu, 22 Jul 2010 00:19:35 -0500
Date: Thu, 22 Jul 2010 01:22:33 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfsprogs: only absolute run-paths are allowed
Message-ID: <20100722052232.GA25620@infradead.org>
References: <alpine.DEB.2.01.1007210408390.3964@bogon.housecafe.de>
	<20100721171319.GA17772@infradead.org>
	<1279737202.1816.16.camel@doink>
	<alpine.DEB.2.01.1007211149320.3964@bogon.housecafe.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1007211149320.3964@bogon.housecafe.de>
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
To: Christian Kujau <lists@nerdbynature.de>
Cc: xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>

I've applied that patch now both to xfsprogs and xfsdump which had
the exact same issue.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
