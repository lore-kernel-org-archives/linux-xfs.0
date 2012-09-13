Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8DHqEB3193374 for <xfs@oss.sgi.com>; Thu, 13 Sep 2012 12:52:14 -0500
Date: Thu, 13 Sep 2012 12:53:16 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: userspace trees
Message-ID: <20120913175316.GR3274@sgi.com>
References: <20120913075026.GA27256@infradead.org>
	<5052142B.3010601@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5052142B.3010601@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Hi Eric,

On Thu, Sep 13, 2012 at 12:13:15PM -0500, Eric Sandeen wrote:
> On 9/13/12 2:50 AM, Christoph Hellwig wrote:
> > It seems with the kernel.org account purge last year and me being way to
> > busy it seems like the -dev trees of the XFS userspace get very little
> > attention.  What do people think about retiring them and using the oss
> > trees exclusively again for now?  Right now the trees are getting a bit
> > out of sync which isn't a good thing.
>
> ISTR it was done in response to a .... fear of SGI being less responsive after
> a different type of account purge.  ;)  
> 
> If SGI wants to be responsible for merging all userspace patches as they
> come in on the list, I'm fine with going back to one tree on oss.

I discussed this with management.  SGI is willing to take on the responsibility
of merging all userspace patches.

I think retiring the -dev trees will resolve the out-of-sync issues we've been
having, and be less confusing for all involved.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
