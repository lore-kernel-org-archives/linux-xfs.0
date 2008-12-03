Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB3AmogE010660 for <xfs@oss.sgi.com>; Wed, 3 Dec 2008 04:48:51 -0600
Date: Wed, 3 Dec 2008 05:48:49 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Assertion failed: atomic_read(&mp->m_active_trans)
Message-ID: <20081203104849.GF15485@infradead.org>
References: <492BB095.1000104@sgi.com> <4934AAA9.5090405@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4934AAA9.5090405@sgi.com>
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

I'd rather fix it properly.  Do you guys have a somewhat reliable
testcase hitting it?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
