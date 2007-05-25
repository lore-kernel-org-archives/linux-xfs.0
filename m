Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 May 2007 22:06:44 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4P56cWt015754
	for <xfs@oss.sgi.com>; Thu, 24 May 2007 22:06:40 -0700
Date: Fri, 25 May 2007 15:06:32 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: RESVSP problems
Message-ID: <20070525050632.GG86004887@sgi.com>
References: <200705241324.53283.lucke@o2.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200705241324.53283.lucke@o2.pl>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: =?iso-8859-1?Q?=C5=81ukasz?= Fibinger <lucke@o2.pl>
Cc: xfs@oss.sgi.com, dgc@sgi.com

On Thu, May 24, 2007 at 01:24:52PM +0200, Å?ukasz Fibinger wrote:
> >>> You've probably hit:
> >>> http://oss.sgi.com/bugzilla/show_bug.cgi?id=418
> >>> unwritten extents remain unwritten after mmap() modifies them
> >>>
> >>> Bug dchinner about it... ;-)
> >> 
> >> Dave, consider it a bugging from my humble self :-)
> 
> > Yeah, yeah ;)
> 
> > I'm waiting to see what happens with Nick's patches in .22 before
> > going any further. If they are not merged into .22, then I think we
> > should push the XFS specific fix in....
> 
> I wonder, what's the status of it, Dave?

A couple of days ago:

http://marc.info/?l=linux-mm&m=117988295814519&w=2

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
