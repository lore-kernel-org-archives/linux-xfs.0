Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Jul 2006 22:10:22 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6L59eDW021005
	for <xfs@oss.sgi.com>; Thu, 20 Jul 2006 22:09:51 -0700
Received: from wobbly.melbourne.sgi.com (wobbly.melbourne.sgi.com [134.14.55.135]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id PAA18774 for <xfs@oss.sgi.com>; Fri, 21 Jul 2006 15:09:06 +1000
Received: from wobbly.melbourne.sgi.com (localhost [127.0.0.1])
	by wobbly.melbourne.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id k6L594gw2000622
	for <xfs@oss.sgi.com>; Fri, 21 Jul 2006 15:09:04 +1000 (EST)
Received: (from nathans@localhost)
	by wobbly.melbourne.sgi.com (SGI-8.12.5/8.12.5/Submit) id k6L592Cx2001537
	for xfs@oss.sgi.com; Fri, 21 Jul 2006 15:09:02 +1000 (EST)
Date: Fri, 21 Jul 2006 15:09:02 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Patches and reviews
Message-ID: <20060721150902.C1998769@wobbly.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi all,

We have an internal process here (@sgi) where all changes are
reviewed by someone else in the team before we merge them into
our local tree.  This is good and effective, but it obviously
isn't visible to people outside SGI.  Christoph has suggested
we try to change this, so we plan to start sending out patches
here before they are merged into our local tree, in the hope
that others outside SGI will also take some time and cast a
critical eye over changes before they go in.

So, this is just a heads up that there will now be occasional
mail coming to the list with "review: ..." in the Subject line
and you're encouraged to try spot the bugs I'll "purposefully"
inject from time to time, just to check you're awake. ;-)  A
response like "Beaauutiful code, Tim" is also helpful (recall
that our internal process requires an ACK).

I also now plan to start CC'ing the list on the mails I send to
Linus and Andrew, requesting our XFS updates be merged into the
mainline kernel.  Hopefully this will also increase visibility
everyone has as to what's going on in XFS with each new kernel.

If you have other suggestions, particularly of things that are
not going to increase my current workload at all, I'm all ears.

cheers.

-- 
Nathan
