Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8D9DA7FE2
	for <xfs@oss.sgi.com>; Thu,  7 Nov 2013 02:16:40 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 142C0AC006
	for <xfs@oss.sgi.com>; Thu,  7 Nov 2013 00:16:36 -0800 (PST)
Date: Thu, 7 Nov 2013 00:16:34 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfstest failures
Message-ID: <20131107081634.GB25157@infradead.org>
References: <20131106105451.GA31283@infradead.org>
	<20131106194417.GF6188@dastard> <527A9F67.6000208@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <527A9F67.6000208@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Nov 06, 2013 at 01:58:31PM -0600, Mark Tinguely wrote:
> 
> >>xfs/206
> >>
> >>	Does not expect the ftype flag.  Didn't we change a generic
> >>	filter to take care of this?
> >
> >xfs/206 has it's own mkfs filter:
> >
> >http://oss.sgi.com/archives/xfs/2013-10/msg00777.html

And why is this patch not merged?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
