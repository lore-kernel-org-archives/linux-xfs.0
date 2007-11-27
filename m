Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 27 Nov 2007 16:10:09 -0800 (PST)
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAS0A1jj032427
	for <linux-xfs@oss.sgi.com>; Tue, 27 Nov 2007 16:10:05 -0800
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1Ix9dO-0004rY-VQ
	for linux-xfs@oss.sgi.com; Tue, 27 Nov 2007 23:14:30 +0000
Received: from p57b4c6bd.dip.t-dialin.net ([87.180.198.189])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Tue, 27 Nov 2007 23:14:30 +0000
Received: from bernd-schubert by p57b4c6bd.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Tue, 27 Nov 2007 23:14:30 +0000
From: Bernd Schubert <bernd-schubert@gmx.de>
Subject: Re: XFS performance problems on Linux x86_64
Date: Wed, 28 Nov 2007 00:13:57 +0100
Message-ID: <fii8bm$6h5$1@ger.gmane.org>
References: <474C8A05.3020604@e-626.net> <20071127220536.GL119954183@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Hello David,

David Chinner wrote:
> 
> # mkfs.xfs -f -l lazy-count=1,version=2,size=128m -i attr=2 -d agcount=4
> # <dev> mount -o logbsize=256k <dev> <mtpt>

thanks, I was also going to ask which are optimal parameters. Just didn't
have the time yet :)
Any idea when these options will be default? 


Cheers,
Bernd
