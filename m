Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8HIXk8m230387 for <xfs@oss.sgi.com>; Thu, 17 Sep 2009 13:33:46 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 653E4460A85
	for <xfs@oss.sgi.com>; Thu, 17 Sep 2009 11:35:00 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Ig7tQEwe3epPScVD for
	<xfs@oss.sgi.com>; Thu, 17 Sep 2009 11:35:00 -0700 (PDT)
Date: Thu, 17 Sep 2009 14:35:00 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS corruption with power failure
Message-ID: <20090917183500.GA29548@infradead.org>
References: <606994882.2142291250648292843.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
	<4A8C1E6E.8020405@jquigley.com> <4A9187C7.9010206@jquigley.com>
	<4A9576F0.2060304@jquigley.com>
	<20090901181341.GC26071@infradead.org>
	<4AAFB7E2.9010902@jquigley.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4AAFB7E2.9010902@jquigley.com>
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
To: John Quigley <jquigley@jquigley.com>
Cc: Christoph Hellwig <hch@infradead.org>, XFS Development <xfs@oss.sgi.com>

On Tue, Sep 15, 2009 at 10:50:58AM -0500, John Quigley wrote:
>> including it's own huge kernel module.  Qemu/kvm now has support for the
>> virtualbox disk images and I will give it a try next.
>
> Ping ... sorry to be a bother.  I've finally gotten some time allocated  
> to look at this at the code level, but I'm unfamiliar with the XFS  
> implementation, and I believe this problem arises as an interaction  
> between XFS and NFS, which causes me heartburn.  I'll report here if I  
> discover anything meaningful.

Sorry, busy time here.  I manage to get your image files converted for
use with qemu, but I can't actually get the image to output anything on
a serial concole.  Given that content in READMe I guess you need some
graphics bit for it?    That's unforuntately not easily doable for me
sitting behind a slow linux with the testbox far away.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
