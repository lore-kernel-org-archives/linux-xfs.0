Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 624757CA0
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2016 17:58:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 27FFC304051
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2016 15:58:05 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	VCqdc3pojoWjmSH0 for <xfs@oss.sgi.com>;
	Thu, 09 Jun 2016 15:58:02 -0700 (PDT)
Date: Fri, 10 Jun 2016 08:57:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfs: add an option to enable reflinks at mount time
Message-ID: <20160609225742.GZ26977@dastard>
References: <1464877150-20457-1-git-send-email-hch@lst.de>
	<1464877150-20457-4-git-send-email-hch@lst.de>
	<20160606112342.GB23695@redhat.com>
	<20160608070459.GC18458@infradead.org>
	<20160608080703.GA8987@redhat.com>
	<20160608081007.GB8987@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160608081007.GB8987@redhat.com>
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
To: xfs@oss.sgi.com, hch@infradead.org

On Wed, Jun 08, 2016 at 10:10:07AM +0200, Carlos Maiolino wrote:
> On Wed, Jun 08, 2016 at 10:07:03AM +0200, Carlos Maiolino wrote:
> > On Wed, Jun 08, 2016 at 12:04:59AM -0700, Christoph Hellwig wrote:
> > > Yes, the comment is wrong.  Any reason you didn't include me in the
> > > reply?  Also it seems your reply-to also magically drops you
> > > from the reply.  Are you using a new mailer? :)
> > 
> > No, no reason, I missed to CC you. Maybe my CTRL-L list-reply in mutt screwed up
> > with the destination fields, I should come back to group replies, thanks for the
> > heads up :)
> 
> Oh crap, I did it again, ok, no more list-reply for me

If you are using mutt, then just use "g" for group reply. I've never
used anything else - it just does the right thing. I didn't even
know that "list-reply" was something that people used....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
