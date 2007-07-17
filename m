Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 17 Jul 2007 10:48:52 -0700 (PDT)
Received: from ns1.invoca.ch (mx1.invoca.ch [157.161.91.34])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6HHmhbm006817
	for <xfs@oss.sgi.com>; Tue, 17 Jul 2007 10:48:45 -0700
Message-ID: <45057.192.168.10.25.1184693423.squirrel@webmail.bi.corp.invoca.ch>
In-Reply-To: <1184611460.6951.10.camel@portatux64.mobile.smithconcepts.com>
References: <alpine.LRH.0.999.0707131356520.25773@chaos.egr.duke.edu>
    <Pine.LNX.4.64.0707131434470.31742@p34.internal.lan>
    <4697CA4D.6020304@etelos.com>
    <Pine.LNX.4.64.0707131535270.2064@p34.internal.lan>
    <20070716024115.GJ12413810@sgi.com>
    <alpine.LRH.0.999.0707161142440.25773@chaos.egr.duke.edu>
    <20070716173447.GA11489@osage.ncsa.uiuc.edu>
    <1184611460.6951.10.camel@portatux64.mobile.smithconcepts.com>
Date: Tue, 17 Jul 2007 19:30:23 +0200 (CEST)
Subject: Re: [Advocacy] Re: 3ware 9650 tips
From: "Simon Matter" <simon.matter@invoca.ch>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Bryan J. Smith" <b.j.smith@ieee.org>
Cc: Stuart Levy <slevy@ncsa.uiuc.edu>, Joshua Baker-LePain <jlb17@duke.edu>, David Chinner <dgc@sgi.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, Jon Collette <jon@etelos.com>, linux-ide-arrays@lists.math.uh.edu, xfs@oss.sgi.com

> [ I removed linux-raid, the only vgers list I posted to (who
> re-posted/responded to my post on linux-fsdevel anyway?), from this
> response. ]
>
> On Mon, 2007-07-16 at 12:34 -0500, Stuart Levy wrote:
>> So they support XFS in Fedora, but not in RHEL??
>> (I've been using Fedora...)
>
> Fedora ships support for all filesystems, and I believe has since Fedora
> Core 2 / kernel 2.6.  RHEL only ships with support for Ext3.
>
> There are various support issues with XFS that I, among others, feel
> could be quickly addressed if Red Hat took a keen interest in supporting
> XFS as a second, supplemental filesystem to Ext3.  I have gone on-record
> several times about this, although I've dropped the advocacy over the
> last few years and just "given up."  I honestly haven't kept up with the
> issues either (like issues with XFS and the 4G/4G kernel model and/or
> 4KiB stacks -- have they been addressed?).

I already wrote quite a long mail for this list yesterday but then decided
not to send it because I also gave up on the issue with RedHat. It has all
been said in the past years and it's still true: You can't compare
anything with XFS on Linux and the competitiors aren't sleeping (just
think ZFS for example). I know that XFS had and maybe still has some minor
issues - but, if RedHat decided to use XFS and put the same effort into it
like they did with Ext3, those problems would have gone long ago.
I'm a long time XFS user starting with RedHat 7.x, and I'm still using it
for choosen filesystem on RHEL3,4,5. I just don't want to live without
lvextend and xfs_growfs.

Simon
