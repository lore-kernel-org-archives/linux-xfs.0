Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 25 May 2007 03:24:31 -0700 (PDT)
Received: from poczta.o2.pl (mx10.go2.pl [193.17.41.74])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4PAOQWt028976
	for <xfs@oss.sgi.com>; Fri, 25 May 2007 03:24:27 -0700
From: =?utf-8?q?=C5=81ukasz_Fibinger?= <lucke@o2.pl>
Reply-To: lucke@o2.pl
Subject: Re: RESVSP problems
Date: Fri, 25 May 2007 12:24:23 +0200
References: <200705241324.53283.lucke@o2.pl> <20070525050632.GG86004887@sgi.com>
In-Reply-To: <20070525050632.GG86004887@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Message-Id: <200705251224.23624.lucke@o2.pl>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

On Friday 25 of May 2007, you wrote:
> On Thu, May 24, 2007 at 01:24:52PM +0200, Å?ukasz Fibinger wrote:
> > >>> You've probably hit:
> > >>> http://oss.sgi.com/bugzilla/show_bug.cgi?id=418
> > >>> unwritten extents remain unwritten after mmap() modifies them
> > >>>
> > >>> Bug dchinner about it... ;-)
> > >>
> > >> Dave, consider it a bugging from my humble self :-)
> > >
> > > Yeah, yeah ;)
> > >
> > > I'm waiting to see what happens with Nick's patches in .22 before
> > > going any further. If they are not merged into .22, then I think we
> > > should push the XFS specific fix in....
> >
> > I wonder, what's the status of it, Dave?
>
> A couple of days ago:
>
> http://marc.info/?l=linux-mm&m=117988295814519&w=2
>

I see. If that's the case, would sharing your 2.6.21 XFS specific fixes (you 
have them, right?) with me be any problem for you?

Cheers,

Luke
