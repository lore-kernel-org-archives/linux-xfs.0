Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAPE5rBj012703 for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 08:05:54 -0600
Date: Tue, 25 Nov 2008 09:05:53 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: New XFS git tree on oss.sgi.com
Message-ID: <20081125140553.GA16553@infradead.org>
References: <492BA7AD.5080007@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <492BA7AD.5080007@sgi.com>
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
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs@oss.sgi.com

Looking over the -dev tree, can you please revert

	http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs.git;a=commitdiff;h=c79ae33eebac1c15aa435fb77362fdc5eff2be4d

All this wasn't needed in the old ptrace tree either, no need to carry it forward.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
