Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB42PTuw010792 for <xfs@oss.sgi.com>; Wed, 3 Dec 2008 20:25:30 -0600
From: Niv Sardi <xaiki@cxhome.ath.cx>
Subject: Re: [patch 12/22] kill dead inode flags
References: <20081202160430.775774000@bombadil.infradead.org>
	<20081202160651.264876000@bombadil.infradead.org>
Date: Thu, 04 Dec 2008 13:24:04 +1100
In-Reply-To: <20081202160651.264876000@bombadil.infradead.org> (Christoph
	Hellwig's message of "Tue, 02 Dec 2008 11:04:42 -0500")
Message-ID: <87r64o7k57.fsf@cxhome.ath.cx>
MIME-Version: 1.0
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

Christoph Hellwig <hch@infradead.org> writes:

> There are a few inode flags around that aren't used anywhere, so remove
> them.  Also update xfsidbg to display all used inode flags correctly.

Thanks for splitting things up, you have your idbg patch somewhere
though ? should the reference to it be removed from the commit ?

Cheers,
-- 
Niv Sardi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
