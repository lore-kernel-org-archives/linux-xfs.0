Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB2GmLC6005666 for <xfs@oss.sgi.com>; Tue, 2 Dec 2008 10:48:21 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 24952164F9C6
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2008 08:48:19 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id kuvG5EFf7LE0RYwQ for <xfs@oss.sgi.com>;
	Tue, 02 Dec 2008 08:48:19 -0800 (PST)
Message-ID: <493565A5.8070504@sandeen.net>
Date: Tue, 02 Dec 2008 10:43:17 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [patch 01/22] fix compile on 32 bit systems
References: <20081202160430.775774000@bombadil.infradead.org>
	<20081202160649.658660000@bombadil.infradead.org>
In-Reply-To: <20081202160649.658660000@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

ACK on this.  I ran into this too on a backport but didn't think it was
a problem upstream, thanks!

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
