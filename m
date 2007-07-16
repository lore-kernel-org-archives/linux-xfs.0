Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Jul 2007 11:43:25 -0700 (PDT)
Received: from smtp108.plus.mail.re1.yahoo.com (smtp108.plus.mail.re1.yahoo.com [69.147.102.71])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6GIhLbm026994
	for <xfs@oss.sgi.com>; Mon, 16 Jul 2007 11:43:21 -0700
Subject: [Advocacy] Re: 3ware 9650 tips
From: "Bryan J. Smith" <b.j.smith@ieee.org>
In-Reply-To: <20070716173447.GA11489@osage.ncsa.uiuc.edu>
References: <alpine.LRH.0.999.0707131356520.25773@chaos.egr.duke.edu>
	 <Pine.LNX.4.64.0707131434470.31742@p34.internal.lan>
	 <4697CA4D.6020304@etelos.com>
	 <Pine.LNX.4.64.0707131535270.2064@p34.internal.lan>
	 <20070716024115.GJ12413810@sgi.com>
	 <alpine.LRH.0.999.0707161142440.25773@chaos.egr.duke.edu>
	 <20070716173447.GA11489@osage.ncsa.uiuc.edu>
Content-Type: text/plain
Date: Mon, 16 Jul 2007 14:44:20 -0400
Message-Id: <1184611460.6951.10.camel@portatux64.mobile.smithconcepts.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stuart Levy <slevy@ncsa.uiuc.edu>
Cc: Joshua Baker-LePain <jlb17@duke.edu>, David Chinner <dgc@sgi.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, Jon Collette <jon@etelos.com>, linux-ide-arrays@lists.math.uh.edu, xfs@oss.sgi.com

[ I removed linux-raid, the only vgers list I posted to (who
re-posted/responded to my post on linux-fsdevel anyway?), from this
response. ]

On Mon, 2007-07-16 at 12:34 -0500, Stuart Levy wrote:
> So they support XFS in Fedora, but not in RHEL??
> (I've been using Fedora...)

Fedora ships support for all filesystems, and I believe has since Fedora
Core 2 / kernel 2.6.  RHEL only ships with support for Ext3.

There are various support issues with XFS that I, among others, feel
could be quickly addressed if Red Hat took a keen interest in supporting
XFS as a second, supplemental filesystem to Ext3.  I have gone on-record
several times about this, although I've dropped the advocacy over the
last few years and just "given up."  I honestly haven't kept up with the
issues either (like issues with XFS and the 4G/4G kernel model and/or
4KiB stacks -- have they been addressed?).

Luckily I have been doing more and more embedded as of late, so I
haven't had to deploy large filesystems.  But I have put in a few
Solaris 10/Opteron systems as NFS/SMB file server solutions in the last
year.  I'm not saying Solaris is "better," I'm just saying I would
really like RHEL Ext3 with an officially supported XFS release.  That's
all.


-- 
Bryan J. Smith         Professional, Technical Annoyance
mailto:b.j.smith@ieee.org   http://thebs413.blogspot.com
--------------------------------------------------------
        Fission Power:  An Inconvenient Solution
