Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1A9unwi042993 for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 03:56:50 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B8BE51409CCB
	for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 01:56:13 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id zdPoah5H99aqO8jf for
	<xfs@oss.sgi.com>; Tue, 10 Feb 2009 01:56:13 -0800 (PST)
Date: Tue, 10 Feb 2009 04:56:12 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS Kernel 2.6.27.7 oopses
Message-ID: <20090210095612.GA29651@infradead.org>
References: <20090130222359.GB32142@theco.de>
	<20090201003744.GB24173@disturbed>
	<20090205053847.GA24841@theco.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090205053847.GA24841@theco.de>
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
To: Ralf Liebenow <ralf@theco.de>
Cc: xfs@oss.sgi.com

On Thu, Feb 05, 2009 at 06:38:47AM +0100, Ralf Liebenow wrote:
> Hmmm ... can I do something to help you find the problem ? I can
> reproduce it by creating some millon of hardlinks to files and then remove some
> million hardlinks with one "rm -rf"

Can you isolated that testcase to a simple shell script?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
