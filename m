Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B5CE47FDA
	for <xfs@oss.sgi.com>; Mon,  3 Feb 2014 04:23:32 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6C073AC00A
	for <xfs@oss.sgi.com>; Mon,  3 Feb 2014 02:23:29 -0800 (PST)
Date: Mon, 3 Feb 2014 02:23:23 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: ensure correct timestamp updates from truncate
Message-ID: <20140203102323.GC11829@infradead.org>
References: <20140110122700.GA12624@localhost> <52CFF402.5080409@oracle.com>
	<20140110133306.GA22918@infradead.org>
	<52CFFD1C.7050005@oracle.com>
	<20140111111045.GA29380@infradead.org>
	<52E8FE81.7040402@redhat.com>
	<20140130080652.GA23758@infradead.org>
	<20140130154701.GP1935@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140130154701.GP1935@sgi.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Jan 30, 2014 at 09:47:01AM -0600, Ben Myers wrote:
> That is v3.13-rc2-14-gc91c46c, so I believe we'll want to Cc: stable on this
> one.  Correct?

Seems so.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
