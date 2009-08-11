Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7BEd9rk139959 for <xfs@oss.sgi.com>; Tue, 11 Aug 2009 09:39:24 -0500
Received: from intranet.easterngraphics.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1CF641483191
	for <xfs@oss.sgi.com>; Tue, 11 Aug 2009 07:39:47 -0700 (PDT)
Received: from intranet.easterngraphics.com (intranet.easterngraphics.com
	[62.80.28.49]) by cuda.sgi.com with ESMTP id GoiKNR9IfZV9iZOe
	for <xfs@oss.sgi.com>; Tue, 11 Aug 2009 07:39:47 -0700 (PDT)
From: Christian Fischer <Christian.Fischer@easterngraphics.com>
Subject: Re: xfs crash, kernel 2.6.29
Date: Tue, 11 Aug 2009 16:39:28 +0200
References: <200908110921.50752.Christian.Fischer@easterngraphics.com>
	<20090811142029.GB30913@infradead.org>
In-Reply-To: <20090811142029.GB30913@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200908111639.28786.Christian.Fischer@easterngraphics.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Lyon <andrew.lyon@gmail.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Tuesday 11 August 2009, Christoph Hellwig wrote:
> On Tue, Aug 11, 2009 at 09:21:50AM +0200, Christian Fischer wrote:
> > We had a new crash yesterday, server uptime maybe 20 hours.
> >
> > This is 2.6.29-xen-r4 from
> > http://code.google.com/p/gentoo-xen-kernel/downloads/list
> >
> > @Eric/Andrew: do we have a xfs or a xen patches problem?
>
> It's a known bug that we just fixed in 2.6.31-rc.  Can you check if this
> patch
>
> 	http://bugzilla.kernel.org/attachment.cgi?id=22590
>
> applies to 2.6.29 (I produced it against 2.6.30)

Yes, I've seen this after sending my first mail.

If there are no patches against 2.6.29 then i have no other chance than trying 
this, or i switch to ext4. But what happens then?

What a bullshit, from one bug to the next, my company kills me.

Thanks for all comments and help.
Christian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
