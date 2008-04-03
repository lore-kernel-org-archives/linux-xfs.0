Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 Apr 2008 17:49:23 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m330nBpS031090
	for <xfs@oss.sgi.com>; Wed, 2 Apr 2008 17:49:15 -0700
Date: Thu, 3 Apr 2008 10:49:34 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Serious XFS crash
Message-ID: <20080403004934.GM103491721@sgi.com>
References: <20080325185453.3a1957dd@galadriel.home> <20080325233611.GW103491721@sgi.com> <20080401140035.46470306@galadriel.home> <20080402055831.GG103491721@sgi.com> <20080402133003.4bb043e4@galadriel.home> <20080402220750.GJ103491721@sgi.com> <20080403002248.4bd263e6@galadriel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080403002248.4bd263e6@galadriel.home>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Thu, Apr 03, 2008 at 12:22:48AM +0200, Emmanuel Florac wrote:
> Le Thu, 3 Apr 2008 08:07:50 +1000 vous écriviez:
> 
> > I'd go and find whatever disk is located at LBA 0xE6DCA-0xE6E2A and
> > replace it - if there are that many repairs needed on it, it's likely
> > to be failing....
> > 
> 
> Oh, it failed  and I changed it. However it's a RAID-5 and though it
> appeared corrected, as you've seen the XFS fs crashed for no apparent
> reason (there was little or no activity at the time of the march 23rd
> crash) later. I was wondering if it could be related, for instance if
> some garbage may have remained hidden somewhere and break it later,
> like a standing nail waiting for someone to step on it...

Yes, entirely possible.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
