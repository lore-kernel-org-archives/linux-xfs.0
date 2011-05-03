Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p43HZoUv022761 for <xfs@oss.sgi.com>; Tue, 3 May 2011 12:35:50 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 080C91B834B4
	for <xfs@oss.sgi.com>; Tue,  3 May 2011 10:39:27 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id NJeW60RN7achzk3r for
	<xfs@oss.sgi.com>; Tue, 03 May 2011 10:39:27 -0700 (PDT)
Date: Tue, 3 May 2011 13:39:27 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfstests 013 - 2.6.35.11 - hang
Message-ID: <20110503173927.GB13209@infradead.org>
References: <BANLkTimAXUtO=oxmLUaHLaRBnGafGP-9kg@mail.gmail.com>
	<20110427171107.GA29196@infradead.org>
	<BANLkTi=xpSa2x4vaD4zQjrz3_JSLkC-hgg@mail.gmail.com>
	<BANLkTimgyWZP_1O_pwm+GXqHsMwhxz1d=A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BANLkTimgyWZP_1O_pwm+GXqHsMwhxz1d=A@mail.gmail.com>
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
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, May 02, 2011 at 11:11:14AM +0530, Ajeet Yadav wrote:
> Is there any thing I left out in xfs related to cache coherency.

I can't think of anything specific, but I have a hard time for other
issues causing problems in these tests.

Did you check if ext2 passes this test?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
